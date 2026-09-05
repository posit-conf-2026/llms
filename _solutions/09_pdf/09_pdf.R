library(ellmer)

recipe_pdfs <- here::here("data/recipes/pdf")
pdf_waffles <- file.path(recipe_pdfs, "CinnamonPeachOatWaffles.pdf")

chat <- chat_posit(model = "zai-org/GLM-5.3-Flash")
chat$chat(
  "Summarize the recipe in this PDF into a list of ingredients and the steps to follow to make the recipe.",
  content_pdf_file(pdf_waffles)
)
