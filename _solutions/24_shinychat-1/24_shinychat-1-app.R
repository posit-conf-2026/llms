library(ellmer)
library(here)
library(shiny)
library(shinychat)

activity_dir <- here("_solutions/24_shinychat-1")
project_dir <- file.path(activity_dir, "blockbuster")
skills_dir <- file.path(activity_dir, "skills")

source(file.path(activity_dir, "_agent.R"))

# STEP 1 - Create a greeting ----
# Add a welcome message and three suggestion cards for the renewal desk.
greeting <- paste(
  "## Welcome to the renewal desk",
  "",
  "Choose a starting point, or write your own request.",
  "",
  "* <span class=\"suggestion submit\">Draft renewal letters for the top three lapsed members.</span>",
  "* <span class=\"suggestion submit\">List the draft letters already in the workspace.</span>",
  "* <span class=\"suggestion submit\">Explain the renewal-letter skill.</span>",
  sep = "\n"
)

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
