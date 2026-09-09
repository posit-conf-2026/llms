import chatlas

# 1. Fill in the blanks below to create a `chat` with a system prompt
#    instructing the model to answer briefly.
chat = chatlas.____(
    ____="Answer in as few words as possible.",
)

# 2. Fill in the blank to ask the first question:
____("What ellmer and chatlas functions create an Anthropic chat?")

# 3. Fill in the blank to ask the second question, using the same chat object:
_____("What about OpenAI?")

# 4. Create a new chat with no system prompt and ask the second question again.
chat2 = chatlas.____()
chat2.____("What about OpenAI?")

# 5. How do the answers to 3 and 4 differ? Why?
