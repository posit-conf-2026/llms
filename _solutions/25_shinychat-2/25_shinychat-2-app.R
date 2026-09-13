library(ellmer)
library(here)
library(shiny)
library(shinychat)

activity_dir <- here("_solutions/25_shinychat-2")
project_dir <- file.path(activity_dir, "blockbuster")
skills_dir <- file.path(activity_dir, "skills")
drafts_dir <- file.path(project_dir, "letters", "drafts")

source(file.path(activity_dir, "_agent.R"))

ui <- page_chat(
  "Blockbuster renewal assistant",
  id = "chat",
  greeting = chat_greeting(
    "## Welcome to the renewal desk\n\nDraft letters, then review them in the drawer."
  ),
  placeholder = "Ask about the renewal campaign...",
  drawer = chat_drawer(
    selectInput("letter", "Draft", choices = character()),
    bslib::input_code_editor(
      "letter_content",
      label = "Letter",
      language = "markdown",
      height = "500px"
    ),
    actionButton("save_letter", "Save letter"),
    title = "Letter drafts",
    open = FALSE
  )
)

server <- function(input, output, session) {
  # STEP 1 - Show a draft ----
  # Let the model update the app to show a specific draft letter in the drawer.
  show_letter <- function(path) {
    filename <- basename(path)
    files <- sort(list.files(drafts_dir, pattern = "\\.md$"))

    if (!filename %in% files) {
      # What should we do with an invalid file name?
      stop("Could not find draft ", filename, ".")
    }

    # Update the draft picker to select `filename`.
    updateSelectInput(session, "letter", choices = files, selected = filename)
    # Open the chat drawer.
    chat_drawer_show("chat", session = session)
    # Return a short message confirming the opened draft.
    paste0("Opened ", filename, " in the letter drawer.")
  }

  tool_show_letter <- tool(
    show_letter,
    description = "Open a draft renewal letter in the app's letter drawer.",
    arguments = list(
      path = type_string("Path to a draft letter in letters/drafts/.")
    )
  )

  client <- chat_posit(model = "zai-org/GLM-5.3-Flash")
  client$register_tool(tool_show_letter)

  # Adds the Blockbuster system prompt, tools, and skills from the last exercise.
  prep_blockbuster_agent(client, project_dir, skills_dir)

  # Connect the app to our Blockbuster agent client
  chat_server("chat", client)

  # Drawer synchronization ----
  draft_files <- reactive({
    invalidateLater(1000, session)
    sort(list.files(drafts_dir, pattern = "\\.md$"))
  })

  observe({
    files <- draft_files()
    selected <- if (!is.null(input$letter) && input$letter %in% files) {
      input$letter
    } else if (length(files)) {
      files[[1]]
    } else {
      NULL
    }
    updateSelectInput(session, "letter", choices = files, selected = selected)
  })

  observeEvent(input$letter, {
    req(input$letter)
    bslib::update_code_editor(
      "letter_content",
      value = brio::read_file(file.path(drafts_dir, input$letter))
    )
  })

  observeEvent(input$save_letter, {
    req(input$letter)
    brio::write_file(input$letter_content, file.path(drafts_dir, input$letter))
  })
}

shinyApp(ui, server)
