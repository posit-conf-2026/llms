# In this workshop, we'll be using the ellmer package to interact with Large
# Language Models (LLMs).
# https://ellmer.tidyverse.org/
library(ellmer)

# Today we're using Posit AI Pass, so you don't need any API keys!
#
# The first time you run this, a browser window opens asking you to log in at
# posit.ai with the email you used to sign up for the workshop.

# ---- Posit AI ----
chat_posit_ai <- chat_posit()
chat_posit_ai$chat(
  "I'm at posit::conf(2026) to learn about programming with LLMs and ellmer!",
  "Write a short social media post for me."
)

# At home, you'd typically connect to a provider directly with an API key:
#
#   1. Sign up for an account with OpenAI or Anthropic
#   2. Add a payment method and get an API key
#   3. Store it in your `.Renviron` as OPENAI_API_KEY or ANTHROPIC_API_KEY
#
# Then chat_openai() and chat_anthropic() pick the keys up automatically:
#
# chat_gpt <- chat_openai()
# chat_gpt$chat("Hello!")
#
# chat_claude <- chat_anthropic()
# chat_claude$chat("Hello!")
