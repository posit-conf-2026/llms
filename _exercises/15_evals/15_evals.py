# %%
import chatlas
from _setup import make_plot_cases, model_graded_qa_posit
from inspect_ai import Task, eval, view

# %% [markdown]
# Keep the seed prompt. Write two prompts of your own.

# %%
prompts = {
    "seed": "What relationship, if any, does this scatter plot show?",
    "prompt_2": "REPLACE THIS WITH A DIFFERENT PROMPT.",
    "prompt_3": "REPLACE THIS WITH ANOTHER PROMPT.",
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
