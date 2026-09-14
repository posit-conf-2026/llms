# %%
# Each case plants a subtle data-quality artifact in the prompt, and the
# eval grades whether each model flags the specific artifact unprompted.
import chatlas
import polars as pl
from _cases import bluff_mini_cases
from _setup import model_graded_qa_posit
from inspect_ai import Task, eval, view

cases = bluff_mini_cases()

# The eval grades responses from two models against the same criteria.
models = {
    "gemma": "google/gemma-4-26B-A4B-it",
    "haiku": "claude-haiku-4-5",
}

# %%
# Run the eval once per model
logs = []

for model_name, model in models.items():
    chat = chatlas.ChatPosit(model=model)
    tsk = Task(
        dataset=cases,
        solver=chat.to_solver(),
        scorer=model_graded_qa_posit(),
        name=f"bluff-mini-{model_name}",
        display_name=f"Bluff mini: {model_name}",
    )
    model_logs = eval(tsk, model=None, epochs=2, display="plain")
    logs.extend((model_name, log) for log in model_logs)

# %%
# Collect pass rates by case
rows = [
    {
        "model": model_name,
        "id": sample.id,
        "passed": sample.scores["model_graded_qa_posit"].value == "C",
    }
    for model_name, log in logs
    for sample in log.samples
]

results = (
    pl.DataFrame(rows)
    .group_by("model", "id", maintain_order=True)
    .agg(
        pl.col("passed").sum().alias("flagged"),
        pl.len().alias("n"),
        pl.col("passed").mean().alias("pass_rate"),
    )
)

results

# %%
# Explore the transcripts in the log viewer
view()
