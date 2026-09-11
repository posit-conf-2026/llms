# AGENTS-attendees.md — workshop attendee guide

This file orients AI assistants (and attendees) helping during the workshop itself.
For developing the workshop materials, see [AGENTS.md](AGENTS.md).

## What this repo is

Materials for the workshop **"Programming with LLMs in R and Python"** at [posit::conf(2026)](https://conf.posit.co/2026/).
Website (setup, schedule, links): <https://posit-conf-2026.github.io/llms>.
Date, venue, and links live in [website/_metadata.yml](website/_metadata.yml).

The workshop teaches LLM programming with **ellmer** (R) and **chatlas** (Python), Posit packages for LLM API integration.
It's dual-language — attendees pick R or Python, and every exercise exists in both.

## LLM access

Attendees use **Posit AI Pass** for LLM access: a free [posit.ai](https://posit.ai) account with a workshop credit grant, no API keys.
Use `chat_posit()` in ellmer (R) or `ChatPosit()` in chatlas (Python); the first call opens a browser login, then stays signed in for the day.
See [website/setup.qmd](website/setup.qmd) for full setup instructions.

## Working on exercises

- Exercises live in [_exercises/](_exercises/), numbered in workshop order (e.g. `01_hello-llm/`).
  Within each directory, the exercise file matches the directory name: `01_hello-llm/01_hello-llm.R`, with `.py` and `.ipynb` equivalents.
- Solutions to every exercise are in [_solutions/](_solutions/) with the same structure — the `help` skill below covers how to use them.
- [_demos/](_demos/) holds code the instructors demo; attendees don't need to edit it.
- Files at the repo root (`website/`, config files, etc.) are workshop infrastructure — attendees generally shouldn't need to touch them.

## Helping attendees

When an attendee asks for help — or types `/help` — invoke the **`help` skill** ([.agents/skills/help/](.agents/skills/help/)).
It carries the full strategy: orient first (setup, dependencies, finding things, exercise help), unblock one step at a time, use `_solutions/` as a reference rather than a handout, honor direct asks for answers, and hand "help me understand X" questions to the `explain` skill ([.agents/skills/explain/](.agents/skills/explain/)), which the workshop context switches to learning mode.

Human help during the workshop goes to the Discord channel (invite link on the setup page).
