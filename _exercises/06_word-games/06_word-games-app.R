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


# Step 1: Create the chat page UI
ui <- ____

server <- function(input, output, session) {
  # Step 2: Create the chat client with the system prompt
  client <- ____
  # Step 3: Connect the chat server to the chat client
  ____("chat", client)
}

shinyApp(ui, server)
