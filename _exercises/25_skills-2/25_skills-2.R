library(ellmer)
library(here)

# Your skills-wired agent from `24_skills-1` is back, but its skill is a bad
# first draft. Open `skills/renewal-letters/SKILL.md` before you continue.
#
# STEP 1: Fix the skill ----
# Start at the top of `skills/renewal-letters/SKILL.md` and work through these
# questions one at a time:
#
# 1. Read only the description. If that were all the agent saw before choosing
#    a skill, what would it know to do?
#
# 2. When will the agent read the first two sentences in the body?
#
# 3. Read the rest of the body beside the store files. Which parts tell the
#    agent something it cannot already find elsewhere?
#
# 4. Where and how does the skill describe the process the agent should follow?
#    Is the process clear? Is there room for interpretation or confusion?
#
project_dir <- here("_exercises/25_skills-2", "blockbuster")
skills_dir <- here("_exercises/25_skills-2", "skills")

# Tools ------------------------------------------------------------------------

read_file <- function(path) {
  paste(readLines(file.path(project_dir, path)), collapse = "\n")
}

write_file <- function(path, content) {
  writeLines(content, file.path(project_dir, path))
  paste0("Wrote ", path, ".")
}

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

read_skill <- function(skill) {
  path <- file.path(skills_dir, skill, "SKILL.md")
  paste(readLines(path), collapse = "\n")
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
    "Use this to create a script, a CSV, or a letter draft."
  ),
  arguments = list(
    path = type_string("Path to a file relative to the Blockbuster workspace."),
    content = type_string("The full contents of the file to write.")
  )
)

tool_list_files <- tool(
  list_files,
  description = paste(
    "List the names of files in the Blockbuster workspace.",
    "Use this to discover new files before you read or edit them."
  )
)

tool_edit_file <- tool(
  edit_file,
  description = paste(
    "Replace one exact span of text in a workspace file.",
    "The existing text must appear exactly once or the tool returns an error.",
    "Use this to patch a script instead of rewriting it."
  ),
  arguments = list(
    path = type_string("Path to a file relative to the Blockbuster workspace."),
    old = type_string("The exact existing text to replace."),
    new = type_string("The text that replaces it.")
  )
)

tool_read_skill <- tool(
  read_skill,
  description = paste(
    "Read the full instructions for a listed skill.",
    "Call this before you do the job the skill describes."
  ),
  arguments = list(
    skill = type_string("Name of the skill to read, such as 'renewal-letters'.")
  )
)

# Agent ------------------------------------------------------------------------

chat <- chat_posit(
  model = "zai-org/GLM-5.3-Flash",
  system_prompt = "
    You are a coding agent for the Last Blockbuster in Bend, Oregon.

    You have one skill: 'renewal-letters' drafts a renewal letter for a
    lapsed Last Blockbuster member. Read it with the read_skill tool before
    you draft a renewal letter.
  "
)

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)
chat$register_tool(tool_list_files)
chat$register_tool(tool_edit_file)
chat$register_tool(tool_read_skill)

# STEP 2: Put your agent to work ----
# After you fix the skill, re-run the letter task from Exercise 24.
chat$chat("____")

# Inspect the whole conversation, including every tool call.
chat
