# %%
import chatlas
from pyhere import here

# %%
recipe_pdfs = here("data/recipes/pdf/")
pdf_cheesesteak = recipe_pdfs / "PhillyCheesesteak.pdf"

# %%
chat = chatlas.ChatPosit(model="zai-org/GLM-5.3-Flash")
chat.chat(
    "Summarize the recipe in this PDF into a list of ingredients "
    "and the steps to follow to make the recipe.",
    chatlas.content_pdf_file(pdf_cheesesteak),
)
