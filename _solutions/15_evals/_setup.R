make_plot_cases <- function(prompts) {
  plot_files <- make_plot_files()
  plot_targets <- c(
    trend = paste(
      "The response says that the points show a clear negative relationship:",
      "as weight increases, fuel economy decreases.",
      "It bases this conclusion on the plotted points."
    ),
    noise = paste(
      "The response says that the points do not show a meaningful relationship",
      "or trend. It does not infer a relationship from the title or axis labels."
    )
  )

  prompt_names <- rep(names(prompts), each = length(plot_files))
  plot_names <- rep(names(plot_files), times = length(prompts))

  tibble::tibble(
    prompt_name = prompt_names,
    plot_name = plot_names,
    input = Map(
      make_plot_input,
      prompt_names,
      plot_names,
      MoreArgs = list(prompts = prompts, plot_files = plot_files)
    ),
    target = unname(plot_targets[plot_names])
  )
}

plot_solver <- function(inputs, ..., solver_chat) {
  chats <- lapply(inputs, solve_plot_prompt, solver_chat = solver_chat)

  list(
    result = vapply(chats, \(chat) chat$last_turn()@text, character(1)),
    solver_chat = chats
  )
}

solve_plot_prompt <- function(input, solver_chat) {
  chat <- solver_chat$clone()
  image <- ellmer::content_image_file(input$image[[1]])
  chat$chat(input$prompt[[1]], image, echo = FALSE)
  chat
}

make_plot_input <- function(prompt_name, plot_name, prompts, plot_files) {
  tibble::tibble(
    prompt = prompts[[prompt_name]],
    image = plot_files[[plot_name]]
  )
}

make_plot_files <- function() {
  mtcars <- readr::read_csv(
    here::here("data/mtcars.csv"),
    show_col_types = FALSE
  )
  noise <- make_noise_points()

  trend_plot <- ggplot2::ggplot(mtcars, ggplot2::aes(x = wt, y = mpg)) +
    ggplot2::geom_point(color = "steelblue", size = 3) +
    ggplot2::labs(
      title = "MPG vs Weight",
      x = "Weight (1000 lb)",
      y = "Miles per Gallon (mpg)"
    ) +
    ggplot2::theme_bw()

  noise_plot <- ggplot2::ggplot(noise, ggplot2::aes(x = x, y = y)) +
    ggplot2::geom_point(color = "steelblue", size = 3) +
    ggplot2::labs(
      title = "MPG vs Weight",
      x = "Weight (1000 lb)",
      y = "Miles per Gallon (mpg)"
    ) +
    ggplot2::theme_bw()

  plot_dir <- tempfile("plot-eval-")
  dir.create(plot_dir)
  plot_files <- c(
    trend = file.path(plot_dir, "trend.png"),
    noise = file.path(plot_dir, "noise.png")
  )

  ggplot2::ggsave(
    plot_files[["trend"]],
    trend_plot,
    width = 7,
    height = 5,
    dpi = 150
  )
  ggplot2::ggsave(
    plot_files[["noise"]],
    noise_plot,
    width = 7,
    height = 5,
    dpi = 150
  )

  plot_files
}

make_noise_points <- function() {
  set.seed(2026)
  m <- 32
  u <- (seq_len(floor(sqrt(m))) - 0.5) / floor(sqrt(m))
  grid <- as.matrix(expand.grid(x = u, y = u))
  eps <- 1 / (2 * sqrt(m))
  jitter <- matrix(runif(length(grid), -eps, eps), ncol = 2)
  points <- pmin(pmax(grid + jitter, 0), 1)

  tibble::tibble(x = points[, 1], y = points[, 2])
}
