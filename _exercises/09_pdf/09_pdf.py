# %%
import chatlas
from pyhere import here

# %%
recipe_pdfs = here("data/recipes/pdf/")
pdf_cheesesteak = recipe_pdfs / "PhillyCheesesteak.pdf"

# %% [markdown]
# Ask the model to turn this messy PDF print-out of a Philly Cheesesteak
# recipe into a clean list of ingredients and steps to follow.

# %%
chat = chatlas.ChatPosit(model="claude-haiku-4-5")
chat.chat(
    "____",
    chatlas.____(pdf_cheesesteak),
)
