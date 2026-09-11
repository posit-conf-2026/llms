library(ellmer)
library(here)

# Your agent from `22_agent-1` gets two more tools today: one to list the
# files in the workspace and one to make targeted edits.
project_dir <- here("_exercises/23_agent-2", "blockbuster")

# Tools ------------------------------------------------------------------------

read_file <- function(path) {
  paste(readLines(file.path(project_dir, path)), collapse = "\n")
}

write_file <- function(path, content) {
  writeLines(content, file.path(project_dir, path))
  paste0("Wrote ", path, ".")
}

tool_read_file <- tool(
  read_file,
  description = paste(
    "Read the full contents of a file in the Blockbuster workspace.",
    "Use this to inspect the store records before you write a script."
  ),
  arguments = list(
    path = type_string("Path to a file relative to the Blockbuster workspace.")
  )
)

tool_write_file <- tool(
  write_file,
  description = paste(
    "Write a file in the Blockbuster workspace, overwriting it if it exists.",
    "Use this to create a script or its output."
  ),
  arguments = list(
    path = type_string("Path to a file relative to the Blockbuster workspace."),
    content = type_string("The full contents of the file to write.")
  )
)

# New tools --------------------------------------------------------------------

list_files <- function() {
  paste(list.files(project_dir), collapse = "\n")
}

edit_file <- function(path, old, new) {
  full <- file.path(project_dir, path)
  content <- paste(readLines(full), collapse = "\n")
  matches <- gregexpr(old, content, fixed = TRUE)[[1]]

  if (identical(matches, -1L)) {
    stop("Could not find the text to replace in ", path, ".")
  }

  if (length(matches) != 1L) {
    stop(
      "Expected one exact match in ",
      path,
      ", but found ",
      length(matches),
      "."
    )
  }

  writeLines(sub(old, new, content, fixed = TRUE), full)
  paste0("Edited ", path, ".")
}

# STEP 1: Document the new tools ----
# Remember: the LLM sees only your descriptions, not the R code.
tool_list_files <- tool(
  list_files,
  description = "____"
)

tool_edit_file <- tool(
  edit_file,
  description = "____",
  arguments = list(
    path = type_string("____"),
    old = type_string("____"),
    new = type_string("____")
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
    For the initial renewal-drive task, use only those records.
    Do not use list_files or look for another export until the user says one arrived.
    You cannot run code or use tools beyond the ones registered for you.
    When a task needs code, write an R script for the user to run.
    Use base R and aggregate() for per-member summaries so join keys stay columns.
    Write scripts with paths relative to the workspace because the user runs
    them from inside the blockbuster folder.
    Do not say a data task is complete until you have written the script.
  "
)

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)

# STEP 2: Register the new tools ----
chat$____(____)
chat$____(____)

# STEP 3: Put your agent to work ----
# First, ask the agent to build the win-back list by writing `find_lapsed.R`.
# Then tell it that the manager found an old register export and dropped it in
# the folder. Do not name the file. Ask it to bring the list up to date.
chat$chat("____")
chat$chat("____")

# Inspect the whole conversation, including every tool call.
chat
