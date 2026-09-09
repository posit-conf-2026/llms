library(shiny)
library(ellmer)
library(shinychat)

system_prompt <- r"--(
We are playing a word guessing game. You are going to think of a random word.
When you do, write it in an HTML comment so that you can remember it, but the
user can't see it.

Do not accidentally reveal the word early by including it in your responses.

Give the user an initial clue and then only answer their questions with yes or
no. When they win, use lots of emojis.
)--"


ui <- page_chat(
  "Word Games",
  placeholder = r"(Say "Let's play" to get started!)"
)

server <- function(input, output, session) {
  client <- chat_posit(system_prompt = system_prompt)
  chat_server("chat", client)
}

shinyApp(ui, server)
