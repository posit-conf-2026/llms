# %%
import chatlas
import polars as pl
from _setup import make_plot_cases, model_graded_qa_posit
from inspect_ai import Task, eval, view
from plotnine import aes, geom_col, ggplot, labs, scale_y_continuous

# %%
prompts = {
    "seed": "What relationship, if any, does this scatter plot show?",
    "visual_evidence": (
        "Describe only the pattern made by the plotted points. "
        "Ignore the title and axis labels."
    ),
    "compare_regions": (
        "Compare the positions of the points on the left and right sides. "
        "What relationship, if any, do they show?"
    ),
}

# %%
# Create the test cases (dataset)
cases = make_plot_cases(prompts)

# Create the task
chat = chatlas.ChatPosit(model="zai-org/GLM-5.3")

tsk = Task(
    dataset=cases,
    solver=chat.to_solver(),
    scorer=model_graded_qa_posit(),
)

# %%
# Run the eval
logs = eval(tsk, model=None, display="plain")

# %%
# Prepare the results
results = (
    pl.DataFrame(
        {
            "prompt_name": [
                sample.metadata["prompt_name"] for sample in logs[0].samples
            ],
            "passed": [
                sample.scores["model_graded_qa_posit"].value == "C"
                for sample in logs[0].samples
            ],
        }
    )
    .group_by("prompt_name", maintain_order=True)
    .agg(pl.col("passed").mean().alias("pass_rate"))
)

# Plot the results
(
    ggplot(results, aes(x="prompt_name", y="pass_rate"))
    + geom_col()
    + scale_y_continuous(limits=(0, 1))
    + labs(x="Prompt", y="Pass rate")
).show()

# %%
# Look at the log viewer
view()
