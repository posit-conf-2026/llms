project_dir <- here("_solutions/24_skills-1", "blockbuster")

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
    stop("Expected one exact match in ", path, ", but found ", length(matches), ".")
  }

  writeLines(sub(old, new, content, fixed = TRUE), full)
  paste0("Edited ", path, ".")
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
