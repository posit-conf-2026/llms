library(ellmer)
library(here)

# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.
project_dir <- here("_solutions/22_agent-1", "blockbuster")
proj_path <- function(path) file.path(project_dir, path)

# STEP 1: Wrap up file reading and writing so the LLM can use them ------------
# 1. Inputs: read_file takes the path the LLM wants to inspect;
#    write_file takes a path and the full contents to put there.
# 2. Work: resolve the path into the workspace (proj_path) and perform the
#    file operation with brio.
# 3. Outputs: read_file returns the file contents; write_file returns a
#    short confirmation because the LLM learns from what we return.

read_file <- function(path) {
  brio::read_file(proj_path(path))
}

write_file <- function(path, content) {
  brio::write_file(content, proj_path(path))
  paste0("Wrote ", path, ".")
}

# STEP 2: Document each function so the LLM knows when and how to use it ----
# Remember: the LLM sees only your descriptions, not the R code.
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
  system_prompt = r"(You are a coding agent for the Last Blockbuster in Bend, Oregon.
Work in the current directory.
When a task needs code, write an R script for the user to run.)"
)

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)

chat$chat(
  r"(It is time for the renewal drive. Which members have gone quiet?
Build the win-back list as `win-back.csv` by writing `find_lapsed.R`
for me to run from inside the blockbuster folder.)"
)
# Inspect the whole conversation, including every tool call.
chat
