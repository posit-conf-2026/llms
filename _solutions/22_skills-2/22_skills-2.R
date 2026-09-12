library(ellmer)
library(here)

# Manager: What did you change in the first draft?
# Author: I moved the use-it and do-not-use-it sentences into the description.
# Manager: Why did you delete the policy and campaign paragraphs?
# Author: The agent can read those facts in the store files.
# Manager: What happened to the conflicting and generic writing advice?
# Author: I deleted it and kept the existing voice, letter checklist, filename
# rule, tier incentives, and promises caveat.
skills_dir <- here("_solutions/22_skills-2", "skills")

source(here("_solutions/22_skills-2", "_tools.R"))

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

chat$chat(paste(
  "Draft renewal letters for the top three members on lapsed.csv.",
  "Save one file for each member in letters/drafts/."
))

# Inspect the whole conversation, including every tool call.
chat
