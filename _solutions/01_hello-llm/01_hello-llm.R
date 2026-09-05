library(ellmer)

# ---- Posit AI ----
chat_posit_ai <- chat_posit()
chat_posit_ai$chat(
  "I'm at posit::conf(2026) to learn about programming with LLMs and ellmer!",
  "Write a short social media post for me."
)
