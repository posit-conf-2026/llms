# We'll use ellmer to interact with models provided by Posit AI.
library(ellmer)

# The first call opens a browser so you can sign in to Posit AI.
chat <- chat_posit()
chat$chat(
  "I'm at posit::conf(2026) to learn about programming with LLMs in R and Python!",
  "Write a short social media post for me."
)
