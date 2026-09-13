list_skills <- function(skills_dir) {
  files <- fs::dir_ls(skills_dir, recurse = TRUE, glob = "**/SKILL.md")
  skills <- lapply(files, \(path) frontmatter::read_front_matter(path)$data)

  paste(
    vapply(
      skills,
      \(skill) paste0("- ", skill$name, ": ", skill$description),
      character(1)
    ),
    collapse = "\n"
  )
}

prep_blockbuster_agent <- function(client, project_dir, skills_dir) {
  path_for <- function(path) file.path(project_dir, path)

  read_file <- function(path) {
    brio::read_file(path_for(path))
  }

  write_file <- function(path, content) {
    full_path <- path_for(path)
    fs::dir_create(fs::path_dir(full_path))
    brio::write_file(content, full_path)
    paste0("Wrote ", path, ".")
  }

  list_files <- function() {
    files <- fs::dir_ls(project_dir, recurse = TRUE, type = "file")
    paste(fs::path_rel(files, start = project_dir), collapse = "\n")
  }

  edit_file <- function(path, old, new) {
    full_path <- path_for(path)
    content <- brio::read_file(full_path)
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

    brio::write_file(sub(old, new, content, fixed = TRUE), full_path)
    paste0("Edited ", path, ".")
  }

  read_skill <- function(skill) {
    brio::read_file(file.path(skills_dir, skill, "SKILL.md"))
  }

  system_prompt <- paste(
    "You are a coding agent for the Last Blockbuster in Bend, Oregon.",
    "",
    "Read a skill with the read_skill tool before you do the job it describes.",
    "For a new renewal letter, list letters/drafts first and write the next version as",
    "letters/drafts/<member-name>-vN.md.",
    "",
    "## Available skills",
    "",
    list_skills(skills_dir),
    sep = "\n"
  )

  client$set_system_prompt(system_prompt)

  client$register_tool(ellmer::tool(
    read_file,
    description = "Read the full contents of a file in the Blockbuster workspace.",
    arguments = list(
      path = ellmer::type_string("Path relative to the Blockbuster workspace.")
    )
  ))
  client$register_tool(ellmer::tool(
    write_file,
    description = "Write a file in the Blockbuster workspace, overwriting it if it exists.",
    arguments = list(
      path = ellmer::type_string("Path relative to the Blockbuster workspace."),
      content = ellmer::type_string("The full contents of the file to write.")
    )
  ))
  client$register_tool(ellmer::tool(
    list_files,
    description = "List files in the Blockbuster workspace, including draft letters."
  ))
  client$register_tool(ellmer::tool(
    edit_file,
    description = "Replace one exact span of text in a Blockbuster workspace file.",
    arguments = list(
      path = ellmer::type_string("Path relative to the Blockbuster workspace."),
      old = ellmer::type_string("The exact existing text to replace."),
      new = ellmer::type_string("The replacement text.")
    )
  ))
  client$register_tool(ellmer::tool(
    read_skill,
    description = "Read the full instructions for a listed skill before doing its job.",
    arguments = list(
      skill = ellmer::type_string("Name of the skill to read.")
    )
  ))

  invisible(client)
}
