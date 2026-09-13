library(ellmer)
library(here)
library(vitals)

vitals::vitals_log_dir_set("./logs")
source(here("_exercises/15_evals", "_setup.R"))

# EDIT HERE ONLY
# Keep the seed prompt. Write two prompts of your own that you want to test out
prompts <- c(
  seed = "What relationship, if any, does this scatter plot show?",
  prompt_2 = "REPLACE THIS WITH A DIFFERENT PROMPT.",
  prompt_3 = "REPLACE THIS WITH ANOTHER PROMPT."
)

# Create the test cases (dataset)
cases <- make_plot_cases(prompts)

# Create the task
tsk <- Task$new(
  dataset = cases,
  solver = plot_solver,
  scorer = model_graded_qa(
    scorer_chat = chat_posit(model = "moonshotai/Kimi-K3")
  ),
  name = "plot-prompt-eval"
)

# Run the eval
tsk$eval(
  solver_chat = chat_posit(model = "zai-org/GLM-5.3"),
  epochs = 3,
  view = FALSE
)

# Prepare the results
results <- tsk$get_samples() |>
  dplyr::summarise(
    pass_rate = mean(score == "C"),
    .by = prompt_name
  )

# Plot the results
ggplot2::ggplot(results, ggplot2::aes(x = prompt_name, y = pass_rate)) +
  ggplot2::geom_col() +
  ggplot2::scale_y_continuous(limits = c(0, 1)) +
  ggplot2::labs(x = "Prompt", y = "Pass rate")

# Look at the log viewer
tsk$view()
