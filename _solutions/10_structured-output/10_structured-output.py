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

# %%
from pydantic import BaseModel, Field


class Ingredient(BaseModel):
    name: str = Field(description="Name of the ingredient")
    quantity: str | None = Field(
        description="Quantity as written, including ranges or fractions",
    )
    unit: str | None = Field(
        description="Unit of measure, if applicable",
    )
    notes: str | None = Field(
        description="Additional notes or preparation details",
    )


class Recipe(BaseModel):
    title: str
    description: str
    ingredients: list[Ingredient]
    instructions: list[str] = Field(description="Step-by-step instructions")


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
