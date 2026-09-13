library(ellmer)
library(here)
library(vitals)

vitals::vitals_log_dir_set("./logs")

source(here("_solutions/15_evals", "_setup.R"))

prompts <- c(
  seed = "What relationship, if any, does this scatter plot show?",
  visual_evidence = paste(
    "Describe only the pattern made by the plotted points.",
    "Ignore the title and axis labels."
  ),
  compare_regions = paste(
    "Compare the positions of the points on the left and right sides.",
    "What relationship, if any, do they show?"
  )
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
