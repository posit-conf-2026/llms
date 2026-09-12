library(ellmer)

recipe_pdfs <- here::here("data/recipes/pdf")
pdf_waffles <- file.path(recipe_pdfs, "CinnamonPeachOatWaffles.pdf")

# Ask the model to turn this messy PDF print-out of a waffle
# recipe into a clean list of ingredients and steps to follow.
chat <- chat_posit(model = "claude-haiku-4-5")
chat$chat(
  "____",
  ____(pdf_waffles)
)
