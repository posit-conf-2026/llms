# %%
from chatlas import ChatAuto, ChatPosit

# %% [markdown]
# List models by calling the `list_models` method on a `Chat` instance.

# %%
ChatPosit().list_models()

# %% [markdown]
# You can also load the models into a Polars DataFrame for easier viewing.

# %%
import polars as pl

models = ChatPosit().list_models()
models = pl.DataFrame(models)
models

# %% [markdown]
# Now try sending the same prompt to different models to compare the responses.

# %%
prompt = "Write a recipe for an easy weeknight dinner."

ChatPosit().chat(prompt)
ChatPosit(model="zai-org/GLM-5.3").chat(prompt)

# %%
# If you have local models installed, try them out with Ollama.
ChatAuto("ollama/gemma3:4b").chat(prompt)