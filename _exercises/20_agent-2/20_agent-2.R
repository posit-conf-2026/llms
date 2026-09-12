library(ellmer)
library(here)

# Your agent from `19_agent-1` gets two more tools today: one to list the
# files in the workspace and one to make targeted edits.
project_dir <- here("_exercises/20_agent-2", "blockbuster")
proj_path <- function(path) file.path(project_dir, path)

# Read/Write Tools -------------------------------------------------------------
# These are the read and write tools from the last exercise.
# Skip ahead to the list files tool.

read_file <- function(path) {
  brio::read_file(proj_path(path))
}

write_file <- function(path, content) {
  brio::write_file(content, proj_path(path))
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

# STEP 1: The list files tool --------------------------------------------------
# Write a description that tells the LLM what this tool does and when to use it.

list_files <- function() {
  paste(list.files(project_dir), collapse = "\n")
}

tool_list_files <- tool(
  list_files,
  description = "____"
)

# STEP 2: The edit file tool ---------------------------------------------------
# Describe each argument so the LLM knows exactly what to pass — especially
# what counts as a valid `old`.

edit_file <- function(path, old, new) {
  full <- proj_path(path)
  content <- brio::read_file(full)
  matches <- gregexpr(old, content, fixed = TRUE)[[1]]

  if (identical(matches, -1L)) {
    cli::cli_abort("Could not find the text to replace in {path}.")
  }

  if (length(matches) != 1L) {
    cli::cli_abort(
      "Expected one exact match in {path}, but found {length(matches)}."
    )
  }

  brio::write_file(sub(old, new, content, fixed = TRUE), full)
  paste0("Edited ", path, ".")
}

tool_edit_file <- tool(
  edit_file,
  description = paste(
    "Replace one exact span of text in a workspace file.",
    "The existing text must appear exactly once or the tool returns an error.",
    "Use this to patch a script instead of rewriting it."
  ),
  arguments = list(
    path = type_string("____"),
    old = type_string("____"),
    new = type_string("____")
  )
)

# STEP 3: Prepare the agent with its tools -------------------------------------
chat <- chat_posit(
  model = "zai-org/GLM-5.3-Flash",
  system_prompt = r"(
You are a coding agent for the Last Blockbuster in Bend, Oregon.
Work in the current directory.
When a task needs code, write an R script for the user to run.)"
)

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)
chat$register_tool(tool_list_files)
chat$register_tool(tool_edit_file)

# STEP 4: Put your agent to work -----------------------------------------------
# Ask the agent to do the same task as the last exercise: build the win-back
# list by writing `find_lapsed.R` for you to run from inside blockbuster/.
chat$chat(
  r"(
It is time for the renewal drive. Which members have gone quiet?
Build the win-back list as `win-back.csv` by writing `find_lapsed.R`
for me to run from inside the blockbuster folder.)"
)

# STEP 5: Your manager found an old register export ----------------------------
# Tell the agent that your manager found an old register export and dropped it
# in the folder. Without naming the file, ask it to bring the list up to date.
chat$chat(
  r"(
The manager found an old register export and dropped it in the folder.
Bring the win-back list up to date.)"
)

# Inspect the whole conversation, including every tool call.
chat
