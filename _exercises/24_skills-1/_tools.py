from pyhere import here

project_dir = here("_exercises/24_skills-1/blockbuster")


def read_file(path: str) -> str:
    """
    Read the full contents of a file in the Blockbuster workspace.

    Use this to inspect the store records before you write a script.
    """
    return (project_dir / path).read_text()


def write_file(path: str, content: str) -> str:
    """
    Write a file in the Blockbuster workspace, overwriting it if it exists.

    Use this to create a script, a CSV, or a letter draft.
    """
    (project_dir / path).write_text(content)
    return f"Wrote {path}."


def list_files() -> str:
    """
    List the names of files in the Blockbuster workspace.

    Use this to discover new files before you read or edit them.
    """
    return "\n".join(p.name for p in project_dir.iterdir())


def edit_file(path: str, old: str, new: str) -> str:
    """
    Replace one exact span of text in a workspace file.

    The existing text must appear exactly once or the tool returns an error.
    Use this to patch a script instead of rewriting it.
    """
    full = project_dir / path
    content = full.read_text()
    matches = content.count(old)

    if matches == 0:
        raise ValueError(f"Could not find the text to replace in {path}.")

    if matches != 1:
        raise ValueError(f"Expected one exact match in {path}, but found {matches}.")

    full.write_text(content.replace(old, new))
    return f"Edited {path}."
