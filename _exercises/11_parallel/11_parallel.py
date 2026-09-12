# %%
import chatlas

# %%
# Read in the recipes from the text files (this time all of the files)
from pyhere import here

recipe_files = list(here("data/recipes/text").glob("*"))
recipes = [f.read_text() for f in recipe_files]

# %% [markdown]
# We'll use the same Pydantic models we defined in `10_structured-output`.
# Optional: Replace the models in the next cell with your own from that
# exercise.

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
    image_url: str | None = Field(
        description="URL of an image of the dish, if present in the source",
    )
    ingredients: list[Ingredient]
    instructions: list[str] = Field(description="Step-by-step instructions")


# %% [markdown]
# Extract all eight recipes with up to four requests active at once.

# %%
chat = chatlas.ChatPosit(model="zai-org/GLM-5.3-Flash")
results = await ____(
    chat=chat,
    prompts=____,
    data_model=____,
    max_active=4,
    on_error="stop",
)
recipes_data = [result.data for result in results]

# %%
[r.title for r in recipes_data]

# %%
# Inspect the extracted recipes in a Polars DataFrame.
import polars as pl

recipes_df = pl.DataFrame([r.model_dump() for r in recipes_data], strict=False)
recipes_df

# %% [markdown]
# Save the recipes, then run `11_recipe-app.R` or `11_recipe-app.py`.

# %%
import json

recipes_structured = [recipe.model_dump() for recipe in recipes_data]

with open(here("data/recipes/recipes.json"), "w") as f:
    json.dump(recipes_structured, f, indent=2)
