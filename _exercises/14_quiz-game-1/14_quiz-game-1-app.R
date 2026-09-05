library(shiny)
library(bslib)
library(ellmer)
library(shinychat)

# UI ---------------------------------------------------------------------------

ui <- page_fillable(
  chat_mod_ui("chat")
)

# Server -----------------------------------------------------------------------

server <- function(input, output, session) {
  client <- chat_posit(
    model = "zai-org/GLM-5.3-Flash",
    # Step 1: Edit `prompt.md` to get the model to play the quiz game.
    system_prompt = interpolate_file(
      here::here("_exercises/14_quiz-game-1/prompt.md")
    )
  )

  chat <- chat_mod_server("chat", client)

  observe({
    # Note: this starts the game when the app launches
    chat$update_user_input(
      value = "Let's play the quiz game!",
      submit = TRUE
    )
  })
}

shinyApp(ui, server)
