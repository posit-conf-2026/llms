# Programming with LLMs

## Setup thoughts

- Positron Assistant: https://positron.posit.co/assistant
  - Requires turning on settings

- Databot (recommended extension), requires setting up PA

## Morning 1: Anatomy of a conversation (90m)

> An introduction to basic LLM concepts and how to use `ellmer` and `chatlas` to interact with LLMs from R and Python. No prior experience with LLMs is assumed, but some programming experience is helpful.

- (10m) Welcome, introductions, workshop expectations
  - Activity: introduce yourself to your neighbors
  - Introduce the instructors and teaching assistants
  - Review the code of conduct and conference logistics
  - Direct participants to the workshop website and Discord
  - Preview the schedule and explain the red/green sticky system
  - Walk through the project structure and where to find exercises, solutions, and demos

- (10m) Set-up and verify API access
  - Explain that API access requires a way to verify, a provider account, payment method, (sometimes) an API key
  - Explain that we will be using Posit AI Pass to access models today
    - Explain any setup still needed
  - Briefly introduce Posit Assistant and workshop skill so that learners can use it to get help throughout the workshop
    - Don't explain what a skill is, just mention that it will know about the workshop
  - *Activity* `_exercises/01_hello-llm`
    - Simple script to verify API access (write an "I'm at posit::conf(2026) social media post")
    - Paste into Posit Assistant and ask to critique it
    - Goal is to verify `chat_posit()` and Posit Assistant connected through Posit AI Pass are both working

- (10m) Think empirically, be pragmatic
  - Getting into the right mindset for working with LLMs
  - This section gives us some extra time to troubleshoot any setup issues
  - Treat LLMs as black boxes and test capabilities empirically
  - Use failures as useful evidence while exploring
  - Start with simple building blocks and develop intuition through hands-on work

- (20m) Anatomy of a conversation
  - Show familiar, chatGPT style conversation
  - We can do this from R/Python too! Show ellmer/chatlas code.
  - How does this work? HTTP APIs. Condensed diagram
  - Look at ellmer/chatlas code more slowly, at a high level
  - Show that you can inspect the chat objects. What do you notice?
  - Messages have roles. Show role diagrams
  - Role table.
  - What about the system prompt? Show how to add with ellmer and chatlas. Inspect chat object again.
  - *Activity* `_exercises/02_word-game` (will need renaming)
    - System prompt: _Answer in as few words as possible._
    - R: _What ellmer function creates an Anthropic chat?_
    - Python: _What chatlas class creates an Anthropic chat?_
    - Follow up in the same chat: _What about OpenAI?_
    - Start a new chat and ask only: _What about OpenAI?_
    - Compare both the content and response style.
  - *Demo* clearbot
    - Use same exchange as from the exercise
    - Show that each request contains the system prompt and full conversation history
    - Clear the chat and show the second example again

- (20m) How do LLMs work? (how to talk to robots)
  - Is this actually a conversation? LLMs are stateless - connect to clearbot demo
    - The model does not remember anything between requests.
    - The client resends the full conversation history with each message.
    - The model reconstructs the conversation from that history.
    - A new chat object starts without that history or system prompt.
  - How to make an LLM
  - Tokens as the fundamental unit
  - *Demo* `_demos/04_token-possibilities`. Possibly updated to be more like https://ngrok.com/blog/compression-is-prediction
  - What if I want to chat back-and-forth, like ChatGPT?
    - live_console/live_browser
  - *Activity* `_exercises/05_live` (possibly skip if short on time)

- (20m) Shinychat basics
  - Activity: `live_console()` and `live_browser()` (or `chat.console()` and `chat.app()`)
  - Making your own shinychat app with `chat.ui()` and `chat.append()`. R users can use the chat module with `chat_mod_server()`.
  - Activity: Reverse the word-guessing game with the word to guess in the system prompt. User has to guess, LLM gives hints.
  - Compare console and browser chat helpers in `ellmer` and `chatlas`
  - Activity: use an interactive chat to write a playful roast
  - Build up a shinychat app step by step in R and Python
  - In R, connect `chat_mod_ui()` and `chat_mod_server()` to an `ellmer` client
  - In Python, connect `ui.chat_ui()` and `ui.Chat()` to an asynchronous `chatlas` stream
  - Discuss why each app session needs its own chat client
  - Finish with interpolation examples used to place a secret word in the system prompt

## Morning 2: Programming with LLMs (90m)

> A deeper dive into the things you can do with LLMs when you're programming with them that are harder to do in a chat UI.

- (15m) Choosing a model
  - Distinguish between a provider, which hosts and serves models, and a model, which is a specific LLM with particular capabilities
  - Briefly introduce the major model families from OpenAI, Anthropic, and Google, with Ollama as an example of running models locally
  - Compare the dimensions that matter when choosing a model:
    - Context window: how much content the model can accept
    - Capabilities: support for images, documents, reasoning, tool use, and structured output
    - Speed and cost: smaller models are generally faster and less expensive
    - Intelligence: larger or reasoning-focused models may perform better on complex tasks
  - Explain how model families commonly offer different size tiers and generations (shorten this section)
    - Moving to a larger tier may improve quality at the cost of speed and price
    - Moving to a newer generation may improve quality without requiring the largest model
    - Model names and availability change frequently, so use provider documentation and independent comparisons rather than memorizing a fixed recommendation
  - Use a practical default: start with a capable general-purpose model, try a smaller model for simple or high-volume work, and move to a larger or reasoning model when evaluation shows that it is needed
  - Posit AI Pass: lets you use models from various providers. We only support models we think are useful for data or coding work.
  - Introduce the provider-specific chat functions/chat() function in `ellmer` and classes in `chatlas`
  - Show how `chat()` and `ChatAuto()` make it easy to switch providers or select a specific model
  - *Activity* `_exercises/07_models`
    - List the models available from Anthropic and OpenAI
    - Send the same prompt to different models
    - Change only the provider or model name, then compare the responses
  - Possible revisions:
    - Move more quickly from the provider/model distinction to the criteria for choosing a model; shorten the seven-slide provider/model diagram sequence
    - Replace the detailed Claude version history with concise, current examples of how Anthropic and OpenAI model families encode size and generation
    - Give local and open-weight models more context, including Ollama, Hugging Face, LM Studio, parameter counts, and common model-naming conventions
    - Replace fixed task-by-model and "favorite models" recommendations with a durable heuristic: start with a recent frontier model, then try a smaller or cheaper model when needed
    - Introduce evaluation with `vitals` as the systematic way to compare model quality and cost for a specific task
    - Keep the existing compare-the-same-prompt activity, adapted for both `ellmer` and `chatlas`
    - Update the provider and model examples to reflect current package support and current model availability

- (15m) Multi-modal input (vision, PDF)
  - Activity: images of food and ask for recipes
  - Activity: take a PDF of a recipe, turn it into markdown

- (15m) Structured output
  - Explain `ellmer::type_*()` or [pydantic model in chatlas](https://posit-dev.github.io/chatlas/get-started/structured-data.html)
  - Activity: Extract rich data from the recipe PDF
  - Note [use_attribute_docstrings](https://docs.pydantic.dev/latest/api/config/#pydantic.config.ConfigDict.use_attribute_docstrings)

- (10m) Parallel/batch calls
  - Support will hopefully land in chatlas before conf
  - Activity: Extract recipe data in parallel or batch

- (35m) Prompting engineering and hallucinations
  - Activity: images of mpg vs weight and ask for interpretation
  - Activity (part 1): same question, but we've replaced the image with random noise
  - Activity (part 2): work with partner to try to get the model to give you a decent interpretation of the random noise image
  - Prompt engineering best practices, in particular the system prompt
  - Activity: create [the prompt for the quiz game show](https://github.com/jcheng5/llm-quickstart/blob/main/02-tools-prompt.md)

## Afternoon 1: Augmented Generation (90m)

> How to add knowledge to LLMs and make them more useful for specific tasks. We implement a simple RAG system, which also naturally introduces the concept of tool calling.

- (10m) Manual RAG
  - Activity: Data science coding assistant
    - Given a data science task using `polars` or `dplyr`, ask an LLM to generate or explain code, first without any context.
    - Then, give it the relevant section of the `polars` or `dplyr` documentation and see how much better the response is.

- (30m) RAG
  - High-level overview of how RAG works
  - Activity: Build a dynamic RAG system
    - We'll have the complete, raw `dplyr` or `polars` documentation.
    - Preprocess and compute embeddings for each chunk using `ragnar` or `llama-index`
      - https://posit-dev.github.io/chatlas/misc/RAG.html#dynamic-retrieval
      - https://ragnar.tidyverse.org/articles/ragnar.html#setting-up-rag
    - Add a tool that searches the embeddings and returns the top few chunks
      - chatlas: this means writing a function
      - ellmer: Use `ragnar`

- (20m) Tool calling
  - Explain how tool calling pattern, mostly following <https://pkg.garrickadenbuie.com/genAI-2025-llms-meet-shiny>
  - Activity: quiz show
    - We provide an R/Python function that plays a sound
      - R: `beepr`, Python: [playsound](https://pypi.org/project/playsound3/)
    - They document the function and register it as a tool in the Quiz Show app

- (30m) Tool calling UI
  - Primarily a series of activities that progressively enhance the quiz show app
  - Activity: Add tool annotations to give the tool an icon and title
  - Activity: Use `ContentToolResult` to return custom title and icon
  - Activity: Track answers and score in the app (add/update value boxes)
  - (Considering) Activity: Add tool to check score and finalize a round with a display of the final score and questions asked.

## Afternoon 2: Beyond Tools (90m)

> A look at more advanced topics, including MCP and agents.

- (10m) querychat
  - Activity: Add querychat into an existing shiny app

- (10m) MCP
  - Overview of MCP and how it works
  - MCP in Positron: https://github.com/posit-dev/positron/issues/8377
    - MCP in VS Code: https://code.visualstudio.com/docs/copilot/customization/mcp-servers

  - Activity: Connect an MCP server to ellmer/chatlas (options from https://github.com/punkpeye/awesome-mcp-servers below)
    - ArXiV: https://github.com/andybrandt/mcp-simple-arxiv
    - webpage screenshot: https://github.com/ananddtyagi/webpage-screenshot-mcp
    - stocky: https://github.com/joelio/stocky
    - fetcher: https://github.com/jae-jae/fetcher-mcp
    - git-ingest: https://github.com/adhikasp/mcp-git-ingest
    - github: https://arc.net/l/quote/bvfqahnx
    - context7: https://github.com/upstash/context7

- (30m) Agents
  - Hadley/Willison definition: Agents are LLMs with a read tool and a write tool
  - The "you know it when you see it" definition: autonomous LLMs, long context, minimal intervention
  - Demobot demo

- (30m) The Future of AI
  - Where do we go from here? Let's talk fears and hopes.

- (5m) Wrap-up
  - Feedback survey
