## Task list

### Setup

- [ ] Quarto website
- [x] Set up description and uv lockfiles
- [ ] Check that package dependencies are correct and functional
- [ ] Add set up instructions for Posit AI Pass and Posit Assistant
- [ ] Add Posit Cloud project instructions and update the workspace screenshot
- [ ] Fill in 2026 conference metadata: hashtag, Discord channel, Cloud link/text, and Wi-Fi
- [x] Remove `quarto.path` from `.vscode/settings.json`
- [ ] Verify no unexpected `_solutions` paths in `_exercises`

### Morning 1

- [ ] 01_hello: Exercise to verify Posit AI Pass and Posit Assistant access
- [ ] 02_word-games: Word guessing game
- [ ] 03_demo_clearbot
- [ ] 04_demo_token-possibilities
- [ ] 05_live: Basic live console/app script (don't need a script for this)
- [ ] 06_word-games-2: Reverse word guessing game
- [ ] Replace the Discord banner with the 2026 image

### Morning 2

- [ ] 07_models: Script to try different models
- [ ] 08_images: Script to try image input
- [ ] 09_pdf: Script to try PDF input
- [ ] 10_structured: Script to try structured output
- [ ] 11_batch: Script to try batch/parallel calls
  - [ ] Save the JSON output and use it in an app
- [ ] 12_plot-image-1: Generate a plot of mpg vs weight, ask for interpretation
- [ ] 13_plot-image-2: Same as above, but with random noise instead of the plot
- [ ] 14_quiz-game-1: Quiz game show prompt engineering

### Afternoon 1

Exercises and demos are listed in workshop order, numbered inline.

Unit 07: Tool Calling

- [x] 15_demo_manual-tools: Human-in-the-loop weather tool, shown at the start of the unit
- [x] 16_demo_tools: Automated weather tool, shown at the start of the unit
- [x] 17_quiz-game-2: Quiz game show with tools for sounds
- [x] 18_quiz-game-3: Quiz game show, add icon and title to tool def
- [x] 19_quiz-game-4: Quiz game show, set title and icon in tool result
- [ ] (considering) 20_tool-extra (new, rewrite tool calling): Optional additional tool exercise, spot reserved

Unit 08: Agents

- [x] 21_demo_assistant: Posit Assistant agent demo, shown at the start of the unit
  - [x] Rework as demo/exercise: instructor sets up the agent conversation, students explore a bit themselves
- [ ] 22_agent-1 (new): Build a simple coding agent with a read tool and a write tool
- [ ] 23_agent-2 (new): Make the coding agent a little better with list files and edit file tools

Unit 09: Agent Skills

- [ ] 24_skills-1 (new): Wire up a skill tool (skill listing in the system prompt, a read tool, or your own skill tool)
- [ ] 25_skills-2 (new): Take the skill from skills-1 and improve it (fix common problems)

Unit 10: Break

### Afternoon 2

Unit 11: shinychat and querychat

- [ ] 26_shinychat-1 (new): First shinychat exercise using the v0.5.0 features like `page_chat()`
- [ ] 27_shinychat-2 (new): Second shinychat exercise
- [ ] 28_querychat
  - [x] Rewrite Python examples to use pandas instead of polars

Unit 12: Wrap-up

No exercises.

### Bonus

- [x] 50_coding-assistant: Getting the weather with a niche R/Python package
- [x] 51_rag: Create dynamic RAG system with dplyr or polars documentation (bonus material, uses `ragnar` in R and `raghilda` in Python)
- [x] 52_mcp: Connect an MCP server to ellmer/chatlas
