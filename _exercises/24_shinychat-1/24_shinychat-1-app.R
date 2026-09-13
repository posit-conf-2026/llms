library(ellmer)
library(here)
library(shiny)
library(shinychat)

activity_dir <- here("_exercises/24_shinychat-1")
project_dir <- file.path(activity_dir, "blockbuster")
skills_dir <- file.path(activity_dir, "skills")

source(file.path(activity_dir, "_agent.R"))

# STEP 1 - Create a greeting ----
# Add a welcome message and three suggestion cards for the renewal desk.
greeting <- "____"

ui <- page_chat(
  "Blockbuster renewal assistant",
  id = "chat",
  greeting = chat_greeting(greeting),
  placeholder = "Ask about the renewal campaign..."
)

server <- function(input, output, session) {
  client <- chat_posit(model = "zai-org/GLM-5.3-Flash")
  # Adds the Blockbuster system prompt, tools, and skills from the last exercise.
  prep_blockbuster_agent(client, project_dir, skills_dir)

  # Connect the app to our Blockbuster agent client
  chat_server("chat", client)
}

shinyApp(ui, server)
