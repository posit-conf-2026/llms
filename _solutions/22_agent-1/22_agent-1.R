library(ellmer)
library(here)

# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.
project_dir <- here("_solutions/22_agent-1", "blockbuster")

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

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)

chat$chat(paste(
  "It is time for the renewal drive. Which members have gone quiet?",
  "Build the win-back list as win-back.csv by writing find_lapsed.R for me to",
  "run from inside the blockbuster folder."
))

# Inspect the whole conversation, including every tool call.
chat
