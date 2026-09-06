library(ellmer)

# List models using the `models_posit()` function.
# Hint: try using the Positron data viewer by calling `View()` on the results.
models_posit()

prompt <- "Write a  recipe for an easy weeknight dinner my kids would like."

# Try sending the same prompt to different models to compare the responses.
chat_posit()$chat(prompt)
chat_posit(model = "zai-org/GLM-5.3")$chat(prompt)

# If you have local models installed, you can use them too.
chat_ollama(model = "gemma3:4b")$chat(prompt)

# At home, you'd typically connect to providers directly with API keys, using
# the direct provider functions instead of `chat_posit()`:
#
# chat_openai(model = "gpt-5")
# chat_anthropic(model = "claude-3-7-sonnet-20250219")
