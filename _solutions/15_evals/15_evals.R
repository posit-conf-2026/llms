library(ellmer)
library(here)
library(vitals)

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
