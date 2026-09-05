library(ellmer)

# Your job: work with a chatbot to roast Hadley Wickham.
#
# The `model` argument picks which model to use. The full list of models
# available through Posit AI is at https://posit.ai/models -- you'll also
# learn how to list them from R or Python later today.
chat <- chat_posit(model = "zai-org/GLM-5.3-Flash")

# Converse with the chatbot in your console.
live_console(chat)

# After a bit, exit the chat and try chatting in a Shiny app.
live_browser(chat)
