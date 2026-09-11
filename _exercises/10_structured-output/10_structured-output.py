# %%
import chatlas

# %%
from pyhere import here

recipe_txt = here("data/recipes/text/")
txt_cheesecake = (recipe_txt / "PhillyCheesesteak.md").read_text()

# %%
print(txt_cheesecake)

# %% [markdown]
# Here's an example of the structured output we want to achieve for a single
# recipe:
#
# ```json
# {
#   "title": "Spicy Mango Salsa Chicken",
#   "description": "A flavorful and vibrant chicken dish...",
#   "ingredients": [
#     {
#       "name": "Chicken Breast",
#       "quantity": "4",
#       "unit": "medium",
#       "notes": "Boneless, skinless"
#     },
#     {
#       "name": "Lime Juice",
#       "quantity": "2",
#       "unit": "tablespoons",
#       "notes": "Fresh"
#     }
#   ],
#   "instructions": [
#     "Preheat grill to medium-high heat.",
#     "In a bowl, combine ...",
#     "Season chicken breasts with salt and pepper.",
#     "Grill chicken breasts for 6-8 minutes per side, or until cooked through.",
#     "Serve chicken topped with the spicy mango salsa."
#   ]
# }
# ```
#
# Hint: include `None` in the type when the input might omit a value.

# %%
from pydantic import BaseModel, Field


class Ingredient(BaseModel):
    name: ____
    quantity: ____ | None = Field(description="____")
    unit: ____ | None = Field(description="____")
    notes: ____ | None = Field(description="____")


class Recipe(BaseModel):
    title: ____
    description: ____
    ingredients: list[_____]
    instructions: list[____] = Field(description="____")


# %%
chat = chatlas.ChatPosit(model="claude-sonnet-5")
recipe = chat.chat_structured(txt_cheesecake, data_model=Recipe)

# %% [markdown]
# `.chat_structured()` returns an instance of the provided Pydantic model, so
# you can access fields directly:

# %%
recipe.title

# %% [markdown]
# Or you can convert it to JSON with pydantic's built-in `.model_dump_json()`
# method:

# %%
print(recipe.model_dump_json(indent=2))
