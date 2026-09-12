library(ellmer)
library(here)

# Your skills-wired agent from `21_skills-1` is back, but its skill is a bad
# first draft. Open `skills/renewal-letters/SKILL.md` before you continue.
# The skills folder also holds three other skills the agent can choose from.
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
# 4. Where and how does the skill describe the process the agent should
#    follow? Is the process clear? Is there room for interpretation or
#    confusion?
#
skills_dir <- here("_exercises/22_skills-2", "skills")

source(here("_exercises/22_skills-2", "_tools.R"))

read_skill <- function(skill) {
  path <- file.path(skills_dir, skill, "SKILL.md")
  brio::read_file(path)
}

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

list_skills <- function(skills_dir) {
  files <- fs::dir_ls(skills_dir, recurse = TRUE, glob = "**/SKILL.md")
  skills <- purrr::map_dfr(
    files,
    \(path) frontmatter::read_front_matter(path)$data
  )

  paste(
    interpolate("- {{ skills$name }}: {{ skills$description }}"),
    collapse = "\n"
  )
}

list_skills(skills_dir)

# Agent ------------------------------------------------------------------------

chat <- chat_posit(
  model = "zai-org/GLM-5.3-Flash",
  system_prompt = interpolate(
    "
    You are a coding agent for the Last Blockbuster in Bend, Oregon.

    Read a skill with the read_skill tool before you do the job it describes.

    ## Available skills

    {{ list_skills(skills_dir) }}
    "
  )
)

chat$register_tool(tool_read_file)
chat$register_tool(tool_write_file)
chat$register_tool(tool_list_files)
chat$register_tool(tool_edit_file)

# Register the read_skill tool.
chat$register_tool(tool_read_skill)

# STEP 2: Put your agent to work ----
# After you fix the skill, re-run the letter task from `21_skills-1`.
chat$chat(paste(
  "Draft renewal letters for the top three members on lapsed.csv.",
  "Save one file for each member in letters/drafts/."
))

# Inspect the whole conversation, including every tool call.
chat
