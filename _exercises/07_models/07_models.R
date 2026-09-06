library(ellmer)

# Step 1: List the models available through Posit AI.
# List models using the `models_posit()` function.
# Hint: try using the Positron data viewer by calling `View()` on the results.
models_____

prompt <- "Write a  recipe for an easy weeknight dinner my kids would like."

# Step 2: Compare responses from different models
# Try sending the same prompt to different models to compare the responses.
chat_posit(model = "____")$chat(prompt)
chat_posit(model = "____")$chat(prompt)

# Bonus: Local models?
# If you have local models installed, you can use them too. Note that you have
# to give a model name to list models, but the model name can be anything.
models_ollama()
chat("ollama/____")$chat(prompt)

# Bonus (at home): rewrite your `chat_posit()` calls to use the direct provider
# functions, which pick up API keys from your `.Renviron`.
#
# chat_____(____)$chat(prompt)
# chat_____(____)$chat(prompt)
