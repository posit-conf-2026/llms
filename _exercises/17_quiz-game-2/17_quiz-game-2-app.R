library(shiny)
library(bslib)
library(beepr)
library(ellmer)
library(shinychat)

# Tools ------------------------------------------------------------------------

#' Plays a sound effect.
#'
#' @param sound Which sound effect to play: `"correct"`, `"incorrect"`,
#'   `"new-round"`, or `"you-win"`.
#' @returns A confirmation that the sound was played.
play_sound <- function(
  sound = c("correct", "incorrect", "new-round", "you-win")
) {
  sound <- match.arg(sound)

  switch(
    sound,
    correct = beepr::beep("coin"),
    incorrect = beepr::beep("wilhelm"),
    "new-round" = beepr::beep("fanfare"),
    "you-win" = beepr::beep("mario")
  )

  glue::glue("The '{sound}' sound was played.")
}

# STEP 1: Create a tool definition with documentation ----
# Remember: you're teaching the LLM how and when to use this function.
tool_play_sound <- tool(
  play_sound,
  description = "____",
  arguments = list(
    ____ = type_____()
  )
)

# UI ---------------------------------------------------------------------------

ui <- page_chat("Quiz Game", id = "chat")

# Server -----------------------------------------------------------------------

server <- function(input, output, session) {
  client <- chat_posit(
    model = "claude-haiku-4-5",
    system_prompt = interpolate_file(
      here::here("_exercises/17_quiz-game-2/prompt.md")
    )
  )

  # STEP 2: Register the tool with the chat client ----
  client$____(____)

  chat_server(
    "chat",
    client,
    greeting = "## Welcome to the Quiz Game!\n\nChoose a theme to begin."
  )
}

shinyApp(ui, server)
