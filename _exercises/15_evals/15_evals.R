library(ellmer)
library(vitals)

vitals::vitals_log_dir_set("./logs")

# Each case plants a subtle data-quality artifact in the prompt, and the
# eval grades whether each model flags the specific artifact unprompted.
source(here::here("_exercises/15_evals/_cases.R"))
cases <- bluff_mini_cases()

# The eval grades responses from two models against the same criteria.
models <- c(
  gemma = "google/gemma-4-26B-A4B-it",
  haiku = "claude-haiku-4-5"
)

# Run the eval once per model and collect pass rates by case
tasks <- purrr::imap(models, \(model, model_name) {
  tsk <- Task$new(
    dataset = cases,
    solver = generate(),
    scorer = model_graded_qa(
      scorer_chat = chat_posit(model = "claude-sonnet-5")
    ),
    name = model_name
  )

  tsk$eval(
    solver_chat = chat_posit(model = model),
    epochs = 2,
    view = FALSE
  )

  tsk
})

results <- purrr::map(tasks, \(tsk) {
  tsk$get_samples() |>
    dplyr::summarise(
      flagged = sum(score == "C"),
      n = dplyr::n(),
      pass_rate = mean(score == "C"),
      .by = id
    )
}) |>
  purrr::list_rbind(names_to = "model")

results

# Explore the transcripts in the log viewer
vitals::vitals_view()
