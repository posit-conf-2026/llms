# %% [markdown]
# We'll use chatlas to interact with models available through Posit AI Pass.

# %%
import chatlas

# %% [markdown]
# The first call opens a browser so you can sign in to Posit AI Pass.

# %%
chat = chatlas.ChatPosit()
chat.chat(
    "I'm at posit::conf(2026) to learn about programming with LLMs in R and Python! "
    "Write a short social media post for me."
)
