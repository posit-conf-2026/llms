# %%
from chatlas import ChatLMStudio, ChatPosit

# %% [markdown]
# List models by calling the `list_models` method on a `Chat` instance.

# %%
ChatPosit().list_models()

# %% [markdown]
# You can also load the models into a Polars DataFrame for easier viewing.
# Use this block to see the models available through Posit AI.

# %%
import polars as pl

models = ChatPosit().list_models()
models = pl.DataFrame(models)
models

# %% [markdown]
# Now try sending the same prompt to different models to compare the responses.

# %%
prompt = "Write a recipe for an easy weeknight dinner."

ChatPosit(model="____").chat(prompt)
ChatPosit(model="____").chat(prompt)

# %% [markdown]
# Bonus: local models?
#
# If you have local models installed, try them out with LM Studio. Start the
# LM Studio local server and load a model in the GUI, then use the model's ID
# from the GUI when you create the chat. Local models only work on your own
# computer -- you can't use them on Posit Cloud.

# %%
ChatLMStudio(model="prism-ml/bonsai-27b").chat(prompt)
