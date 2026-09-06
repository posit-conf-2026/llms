library(shiny)
library(ellmer)
library(shinychat)

system_prompt <- r"--(
We are playing a word guessing game. You are going to think of a random word.
When you do, write it in an HTML comment so that you can remember it, but the
user can't see it.

Give the user an initial clue and then only answer their questions with yes or
no. When they win, use lots of emojis.
)--"


# Step 1: Create the chat page UI
ui <- ____

server <- function(input, output, session) {
  # Step 2: Create the chat client with the system prompt
  client <- ____
  # Step 3: Connect the chat server to the chat client
  ____("chat", client)
}

shinyApp(ui, server)
