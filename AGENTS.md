# Programming with LLMs in R and Python

This file orients agents developing the workshop materials.
For agents helping attendees during the workshop, see [AGENTS-attendees.md](AGENTS-attendees.md).

## What this repo is

Materials for the workshop **"Programming with LLMs in R and Python"** at [posit::conf(2026)](https://conf.posit.co/2026/).
Repo: <https://github.com/posit-conf-2026/llms>; website: <https://posit-conf-2026.github.io/llms>.
Date, venue, links, and other workshop metadata live in [website/_metadata.yml](website/_metadata.yml) (referenced in pages as `{{< meta workshop.* >}}` shortcodes).

The workshop teaches LLM programming with **ellmer** (R) and **chatlas** (Python), Posit packages for LLM API integration.
It's dual-language — attendees pick R or Python, and exercises and solutions exist in both.
See [website/index.qmd](website/index.qmd) for the introduction and [website/about/index.qmd](website/about/index.qmd) for the team.

## Setup

Attendee-facing setup instructions are in [website/setup.qmd](website/setup.qmd) — defer to it for specifics.
In short: LLM access via **Posit AI Pass** (no API keys; `chat_posit()` in ellmer, `ChatPosit()` in chatlas), a prepared Posit Cloud workspace as the recommended path, **pak** ([DESCRIPTION](DESCRIPTION)) for R deps, and **uv** ([pyproject.toml](pyproject.toml)) for Python deps.

## Repo layout

- [website/](website/) — Quarto website: pages (`index.qmd`, `setup.qmd`, `workshop.qmd`, `workshop-NN.qmd`), `slides/`, `about/`, `partials/`, `assets/`.
- [_exercises/](_exercises/), [_solutions/](_solutions/), [_demos/](_demos/) — numbered activity directories with paired R and Python files.
- [_setup.R](_setup.R) — direct-install fallback list of R packages.
- [outline.md](outline.md), [_todo.md](_todo.md) — working notes.

## Slides & workshop flow

Slides are Quarto revealjs decks in [website/slides/](website/slides/), rendered with the website.
[slides-01.qmd](website/slides/slides-01.qmd) is the orientation deck and defines the attendee-facing vocabulary: **Your Turn** exercises in `_exercises/`, mirrored solutions in `_solutions/`, demos in `_demos/`.
It also shows the exercise file naming pattern (e.g. `_exercises/NN_name/NN_name.R` with `.py` / `.ipynb` equivalents).

## Common tasks

The [Makefile](Makefile) has the build/setup tasks and is self-documenting via `make help`.
Not every attendee has `make`, so each target is written such that the underlying commands can be copied and run directly.

## Conventions

- Keep R and Python versions of exercises in sync.
- Numbered directory prefixes define activity order; `-break` pages mark schedule breaks.
- Python scripts in exercises/solutions are jupytext-paired with notebooks — edit the `.py`, not the `.ipynb`; a pre-commit hook in `.githooks` regenerates notebooks from staged `.py` files.
- Commit small, logically grouped commits using conventional commit messages.
- Write prose markdown with one sentence per line.
