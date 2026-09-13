library(shiny)
library(ellmer)
library(shinychat)

# Picks a random word for the model to keep secret from a list.
word <- sample(readLines(here::here("data/words.txt")), 1)

system_prompt <- interpolate(
  r"--(
We are playing a word guessing game. The secret word is "{{ word }}".

Never say the secret word out loud. Give the user an initial clue and then
only answer their questions with yes or no. When they win, use lots of emojis.
)--"
)


ui <- page_chat(
  "Word Games",
  placeholder = r"(Say "Let's play" to get started!)"
)

server <- function(input, output, session) {
  client <- chat_posit(system_prompt = system_prompt)
  chat_server("chat", client)
}

shinyApp(ui, server)
