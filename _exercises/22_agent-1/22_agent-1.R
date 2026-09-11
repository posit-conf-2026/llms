library(ellmer)
library(here)

# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.
project_dir <- here("_exercises/22_agent-1", "blockbuster")

# Tools ------------------------------------------------------------------------

read_file <- function(path) {
  paste(readLines(file.path(project_dir, path)), collapse = "\n")
}

write_file <- function(path, content) {
  writeLines(content, file.path(project_dir, path))
  paste0("Wrote ", path, ".")
}

# STEP 1: Document each function so the LLM knows when and how to use it ----
# Remember: the LLM sees only your descriptions, not the R code.
tool_read_file <- tool(
  read_file,
  description = "____",
  arguments = list(
    path = type_string("____")
  )
)

tool_write_file <- tool(
  write_file,
  description = "____",
  arguments = list(
    path = type_string("____"),
    content = type_string("____")
  )
)

# Agent ------------------------------------------------------------------------

chat <- chat_posit(
  model = "zai-org/GLM-5.3-Flash",
  system_prompt = "
    You are a coding agent for the Last Blockbuster in Bend, Oregon.
    Start by reading README.md and every store document it names.
    The initial workspace has members.csv, rentals.csv, and dues.csv.
    Do not guess paths that are not in those records.
    Do not read rentals.csv with read_file because it has 1,500 rows.
    Write a script that reads the rental log instead.
    Write the first script for only the files that exist now.
    Do not add support for future exports until the user asks you to update it.
    You cannot run code or use tools beyond the ones registered for you.
    When a task needs code, write an R script for the user to run.
    Use base R and aggregate() for per-member summaries so join keys stay columns.
    Write scripts with paths relative to the workspace because the user runs
    them from inside the blockbuster folder.
    Do not say a data task is complete until you have written the script.
  "
)

# STEP 2: Register both tools with the chat ----
chat$____(____)
chat$____(____)

# STEP 3: Put your agent to work ----
# Ask the agent to build the win-back list as `win-back.csv`.
# It cannot run code, so it must write `find_lapsed.R` for you to run from
# inside `blockbuster/`.
chat$chat("____")

# Inspect the whole conversation, including every tool call.
chat
