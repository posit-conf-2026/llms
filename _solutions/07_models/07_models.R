library(ellmer)

# List models using the `models_posit()` function.
# Hint: try using the Positron data viewer by calling `View()` on the results.
models_posit()

prompt <- "Write a recipe for an easy weeknight dinner."

# Try sending the same prompt to different models to compare the responses.
chat_posit()$chat(prompt)
chat_posit(model = "zai-org/GLM-5.3")$chat(prompt)

# If you have local models installed, you can use them too.
# (Local models only work on your own computer -- you can't use them on
# Posit Cloud.)
chat_lmstudio(model = "prism-ml/bonsai-27b")$chat(prompt)
