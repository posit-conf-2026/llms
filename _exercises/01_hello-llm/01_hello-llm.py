# %% [markdown]
# In this workshop, we'll be using
# [chatlas](https://posit-dev.github.io/chatlas) to interact with large
# language models (LLMs).
#
# Today we're using Posit AI Pass, so you don't need any API keys! The first
# time you run this, a browser window opens asking you to log in at posit.ai
# with the email you used to sign up for the workshop.

# %%
import chatlas

# %% [markdown]
# ## Posit AI

# %%
chat_posit_ai = chatlas.ChatPosit()
chat_posit_ai.chat(
    "I'm at posit::conf(2026) to learn about programming with LLMs and chatlas! "
    "Write a short social media post for me."
)

# %% [markdown]
# At home, you'd typically connect to a provider directly with an API key:
#
# 1. Sign up for an account with OpenAI or Anthropic
# 2. Add a payment method and get an API key
# 3. Store it in a `.env` file as `OPENAI_API_KEY` or `ANTHROPIC_API_KEY`
#
# Then use `ChatOpenAI()` or `ChatAnthropic()`, which pick the keys up
# automatically:
#
# ```python
# import dotenv
#
# dotenv.load_dotenv()
#
# chat_gpt = chatlas.ChatOpenAI()
# chat_gpt.chat("Hello!")
# ```

# %%
