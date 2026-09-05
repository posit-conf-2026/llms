# %%
import chatlas

# %% [markdown]
# Your job: work with a chatbot to roast Hadley Wickham.
#
# The `model` argument picks which model to use. The full list of models
# available through Posit AI is at https://posit.ai/models -- you'll also
# learn how to list them from R or Python later today.

# %%
chat = chatlas.ChatPosit(model="zai-org/GLM-5.3-Flash")

# %% [markdown]
# Converse with the chatbot in your console.

# %%
chat.console()

# %% [markdown]
# After a bit, exit the chat and try chatting in a Shiny app.

# %%
chat.app()
