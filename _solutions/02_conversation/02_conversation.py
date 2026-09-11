import chatlas

chat = chatlas.ChatPosit(
    system_prompt="Answer in as few words as possible."
)
chat.chat("What ellmer and chatlas functions create an Anthropic chat?")
chat.chat("What about OpenAI?")

# Compare with a fresh chat, no system prompt:
chat2 = chatlas.ChatPosit()
chat2.chat("What about OpenAI?")
