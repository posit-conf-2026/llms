library(ellmer)
library(here)

# Your agent from `23_agent-2` gets a new ability today: skills.
# A skill is a folder with a SKILL.md file: frontmatter with a name and
# description, then instructions for a job.
# `skills/renewal-letters/SKILL.md` holds the letter-writing instructions.
skills_dir <- here("_exercises/24_skills-1", "skills")

source(here("_exercises/24_skills-1", "_tools.R"))

# Skills -----------------------------------------------------------------------

list_skills <- function(skills_dir) {
  files <- fs::dir_ls(skills_dir, recurse = TRUE, glob = "SKILL.md")
  skills <- purrr::map_dfr(
    files,
    \(path) frontmatter::read_front_matter(path)$data
  )

  paste(
    interpolate("- {{ skills$name }}: {{ skills$description }}"),
    collapse = "\n"
  )
}

read_skill <- function(skill) {
  path <- fs::path(skills_dir, skill, "SKILL.md")
  brio::read_file(path)
}

# STEP 1: Document the read_skill tool ----
# Remember: the LLM sees only your description, not the R code.
tool_read_skill <- tool(
  read_skill,
  description = "____",
  arguments = list(
    skill = type_string("Name of the skill to read.")
  )
)

# Agent ------------------------------------------------------------------------

# STEP 2: List your skills in the system prompt ----
# Add each skill's name and description to the system prompt.
chat <- chat_posit(
  model = "zai-org/GLM-5.3-Flash",
  system_prompt = interpolate(
    "
    You are a coding agent for the Last Blockbuster in Bend, Oregon.

    Read a skill with the read_skill tool before you do the job it describes.

    ## Available skills

    ________
    "
  )
)

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)
chat$register_tool(tool_list_files)
chat$register_tool(tool_edit_file)

# STEP 3: Register the read_skill tool ----
chat$____(____)

# STEP 4: Put your agent to work ----
# Draft renewal letters for the top three members on `lapsed.csv`.
# Save one file for each member in `letters/drafts/`.
# Watch for the agent to read the skill before it starts drafting.
chat$chat(paste(
  "Draft renewal letters for the top three members on lapsed.csv.",
  "Save one file for each member in letters/drafts/."
))

# Inspect the whole conversation, including every tool call.
chat
