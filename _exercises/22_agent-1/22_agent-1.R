library(ellmer)
library(here)

# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.
project_dir <- here("_exercises/22_agent-1", "blockbuster")
proj_path <- function(path) file.path(project_dir, path)

# STEP 1: Wrap up file reading and writing so the LLM can use them ------------

# The {brio} package gives us two great functions for reading and writing files:
#
#   * brio::read_file()
#   * brio::write_file()
#
# But we're not going to just give those directly to the LLM! We wrap the
# operations we trust it with into functions and hand those to it as tools.
# For each one, think through:
#
#   1. What inputs do we want from the LLM?
#      (e.g. what should it tell us about a file for us to act on its behalf?)
#      (and why are we using `proj_path(path)`?)
#   2. What do we do with that input?
#      (This is where we do the real work for the model.)
#   3. What outputs do we send back to the LLM?
#

read_file <- function(path) {
  path <- proj_path(path)
  # ____
}

write_file <- function(path, content) {
  path <- proj_path(path)
  # ____
}

# STEP 2: Document each function so the LLM knows when and how to use it ----
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
  system_prompt = r"(
You are a coding agent for the Last Blockbuster in Bend, Oregon.
Work in the current directory.
When a task needs code, write an R script for the user to run.)"
)

# STEP 3: Register both tools with the chat client ----
chat$____(____)
chat$____(____)

# STEP 4: Put your agent to work ----
# Ask the agent to build the win-back list as `win-back.csv`.
# It cannot run code, so it must write `find_lapsed.R` for you to run from
# inside `blockbuster/`.
chat$chat(
  r"(
It is time for the renewal drive. Which members have gone quiet?
Build the win-back list as `win-back.csv` by writing `find_lapsed.R`
for me to run from inside the blockbuster folder.)"
)

# Inspect the whole conversation, including every tool call.
chat
