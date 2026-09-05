# %%
from chatlas import ChatAuto, ChatPosit

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
prompt = "Write a  recipe for an easy weeknight dinner my kids would like."

ChatPosit(model="____").chat(prompt)
ChatPosit(model="____").chat(prompt)

# %% [markdown]
# Bonus: local models?
#
# If you have local models installed, try them out with Ollama. Note that you
# have to give a model name to list models, but the model name can be anything.

# %%
ChatAuto("ollama/any-model-name").list_models()
ChatAuto("ollama/gemma3:4b").chat(prompt)

# %% [markdown]
# Bonus (at home): rewrite your `ChatPosit()` calls to use the direct provider
# functions, which pick up API keys from your `.env` file.
#
# ```python
# from chatlas import ChatAnthropic, ChatOpenAI
#
# Chat____(____)
# Chat____(____)
# ```

# %%
