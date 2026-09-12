library(ellmer)

# Read in the recipes from text files (this time all of the recipes)
recipe_files <- fs::dir_ls(here::here("data/recipes/text"))
recipes <- purrr::map(recipe_files, brio::read_file)

# Use the type_recipe we defined in `10_structured-output`.
type_recipe <- type_object(
  title = type_string(),
  description = type_string(),
  ingredients = type_array(
    type_object(
      name = type_string(),
      quantity = type_string(required = FALSE),
      unit = type_string(required = FALSE),
      notes = type_string(required = FALSE)
    )
  ),
  instructions = type_array(type_string())
)

# Extract all eight recipes with up to four requests active at once.
recipes_data <- ____(
  chat_posit(model = "zai-org/GLM-5.3-Flash"),
  prompts = ____,
  type = ____,
  max_active = 4,
  on_error = "stop"
)

# Inspect the extracted recipes.
recipes_tbl <- dplyr::as_tibble(recipes_data)
recipes_tbl

# Save the recipes, then run `11_recipe-app.R` or `11_recipe-app.py`.
jsonlite::write_json(
  recipes_data,
  here::here("data/recipes/recipes.json"),
  auto_unbox = TRUE,
  pretty = TRUE
)
