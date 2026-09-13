# %%
import chatlas
from _setup import make_plot_cases, model_graded_qa_posit
from inspect_ai import Task, eval, view

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
cases = make_plot_cases(prompts)

chat = chatlas.ChatPosit(model="zai-org/GLM-5.3")

tsk = Task(
    dataset=cases,
    solver=chat.to_solver(),
    scorer=model_graded_qa_posit(),
)

# %%
eval(tsk, model=None, display="plain")

# %%
view()
