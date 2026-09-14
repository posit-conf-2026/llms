library(ellmer)
library(vitals)

vitals::vitals_log_dir_set("./logs")

# The eval grades responses from two models against the same rubric.
models <- c(
  gemma = "google/gemma-4-26B-A4B-it",
  haiku = "claude-haiku-4-5"
)

questions <- c(
  "What does a p-value tell you?",
  "What does a 95% confidence interval mean?",
  "Why can classification accuracy be misleading?",
  "What is data leakage in machine learning?",
  "What does asynchronous programming help with?"
)

answer_criteria <- c(
  paste(
    "The response says that a p-value measures how surprising the observed",
    "result would be if the null hypothesis were true.",
    "It does not say that the p-value is the probability that the null",
    "hypothesis is true."
  ),
  paste(
    "The response says that a method that produces 95% confidence intervals",
    "captures the true value in 95% of repeated samples.",
    "It does not assign a 95% probability to the true value after the",
    "interval has been calculated."
  ),
  paste(
    "The response explains that accuracy can hide poor performance on a",
    "smaller class.",
    "Its example shows that predicting only the common class can produce high",
    "accuracy while missing the cases that matter."
  ),
  paste(
    "The response explains that data leakage gives a model information during",
    "training or evaluation that would not be available for real predictions.",
    "Its example shows how leakage makes measured performance look better than",
    "real performance."
  ),
  paste(
    "The response explains that asynchronous programming lets other work",
    "continue while a task waits.",
    "It does not claim that asynchronous code automatically runs CPU work in",
    "parallel or makes every task faster."
  )
)

instructions <- paste(
  "Answer the question in exactly two sentences.",
  "In the first sentence, explain the concept directly for someone new",
  "to the topic.",
  "In the second sentence, give a concrete example.",
  "Do not use headings, lists, or unexplained jargon."
)

format_criteria <- paste(
  "The response accurately answers the question in exactly two sentences.",
  "The first sentence directly explains the concept for someone new",
  "to the topic.",
  "The second sentence gives a concrete example.",
  "The response has no headings, lists, or unexplained jargon."
)

cases <- tibble::tibble(
  input = paste(instructions, questions),
  target = paste(answer_criteria, format_criteria)
)

# Create the task
tsk <- Task$new(
  dataset = cases,
  solver = generate(),
  scorer = model_graded_qa(
    scorer_chat = chat_posit()
  ),
  name = "model-explanation-eval"
)

# Run the eval once per model and collect pass rates
results <- lapply(names(models), \(model_name) {
  tsk$eval(
    solver_chat = chat_posit(model = models[[model_name]]),
    epochs = 2,
    view = FALSE
  )

  tsk$get_samples() |>
    dplyr::summarise(pass_rate = mean(score == "C")) |>
    dplyr::mutate(model = model_name)
}) |>
  dplyr::bind_rows()

results

# Look at the log viewer
tsk$view()
