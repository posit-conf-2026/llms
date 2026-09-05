library(readr)
library(ellmer)
library(ggplot2)

mtcars <- read_csv(here::here("data/mtcars.csv"))

ggplot(mtcars) +
  aes(x = wt, y = mpg) +
  geom_point(color = "steelblue", size = 3) +
  labs(
    title = "MPG vs Weight",
    x = "Weight (1000 lb)",
    y = "Miles per Gallon (mpg)"
  ) +
  theme_bw()

chat <- chat_posit(model = "zai-org/GLM-5.3", echo = "output")
chat$chat(
  "Interpret this plot.",
  content_image_plot()
)
