library(ellmer)
library(here)
library(vitals)

source(here("_exercises/15_evals", "_setup.R"))

# Keep the seed prompt. Write two prompts of your own.
prompts <- c(
  seed = "What relationship, if any, does this scatter plot show?",
  prompt_2 = "REPLACE THIS WITH A DIFFERENT PROMPT.",
  prompt_3 = "REPLACE THIS WITH ANOTHER PROMPT."
)

cases <- make_plot_cases(prompts)

tsk <- Task$new(
  dataset = cases,
  solver = plot_solver,
  scorer = model_graded_qa(
    scorer_chat = chat_posit(model = "moonshotai/Kimi-K3")
  ),
  name = "plot-prompt-eval"
)

tsk$eval(
  solver_chat = chat_posit(model = "zai-org/GLM-5.3"),
  view = FALSE
)

tsk$view()
