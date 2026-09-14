# %%
import chatlas
import polars as pl
from _setup import model_graded_qa_posit
from inspect_ai import Task, eval, view
from inspect_ai.dataset import MemoryDataset, Sample

# %%
# The eval grades responses from two models against the same rubric.
models = {
    "gemma": "google/gemma-4-26B-A4B-it",
    "haiku": "claude-haiku-4-5",
}

# %%
cases_data = [
    (
        "What does a p-value tell you?",
        "The response says that a p-value measures how surprising the observed "
        "result would be if the null hypothesis were true. "
        "It does not say that the p-value is the probability that the null "
        "hypothesis is true.",
    ),
    (
        "What does a 95% confidence interval mean?",
        "The response says that a method that produces 95% confidence intervals "
        "captures the true value in 95% of repeated samples. "
        "It does not assign a 95% probability to the true value after the "
        "interval has been calculated.",
    ),
    (
        "Why can classification accuracy be misleading?",
        "The response explains that accuracy can hide poor performance on a "
        "smaller class. "
        "Its example shows that predicting only the common class can produce high "
        "accuracy while missing the cases that matter.",
    ),
    (
        "What is data leakage in machine learning?",
        "The response explains that data leakage gives a model information during "
        "training or evaluation that would not be available for real predictions. "
        "Its example shows how leakage makes measured performance look better than "
        "real performance.",
    ),
    (
        "What does asynchronous programming help with?",
        "The response explains that asynchronous programming lets other work "
        "continue while a task waits. "
        "It does not claim that asynchronous code automatically runs CPU work in "
        "parallel or makes every task faster.",
    ),
]

instructions = (
    "Answer the question in exactly two sentences. "
    "In the first sentence, explain the concept directly for someone new "
    "to the topic. "
    "In the second sentence, give a concrete example. "
    "Do not use headings, lists, or unexplained jargon."
)

format_criteria = (
    "The response accurately answers the question in exactly two sentences. "
    "The first sentence directly explains the concept for someone new "
    "to the topic. "
    "The second sentence gives a concrete example. "
    "The response has no headings, lists, or unexplained jargon."
)

cases = MemoryDataset(
    [
        Sample(
            input=f"{instructions} {question}",
            target=f"{answer_criteria} {format_criteria}",
        )
        for question, answer_criteria in cases_data
    ],
    name="model-explanation-eval",
)

# %%
# Run the eval once per model
logs = []

for model_name, model in models.items():
    chat = chatlas.ChatPosit(model=model)
    tsk = Task(
        dataset=cases,
        solver=chat.to_solver(),
        scorer=model_graded_qa_posit(),
        name=f"model-explanation-eval-{model_name}",
        display_name=f"Explanation eval: {model_name}",
    )
    model_logs = eval(tsk, model=None, epochs=2, display="plain")
    logs.extend((model_name, log) for log in model_logs)

# %%
# Prepare the results
results = (
    pl.DataFrame(
        {
            "model": [
                model_name
                for model_name, log in logs
                for sample in log.samples
            ],
            "passed": [
                sample.scores["model_graded_qa_posit"].value == "C"
                for model_name, log in logs
                for sample in log.samples
            ],
        }
    )
    .group_by("model", maintain_order=True)
    .agg(pl.col("passed").mean().alias("pass_rate"))
)

results

# %%
# Look at the log viewer
view()
