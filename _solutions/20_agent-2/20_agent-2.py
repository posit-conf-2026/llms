# %%
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your agent from `19_agent-1` gets two more tools today: one to list the
# files in the workspace and one to make targeted edits.

# %%
project_dir = here("_solutions/20_agent-2/blockbuster")


# %%
def read_file(path: str) -> str:
    """
    Read the full contents of a file in the Blockbuster workspace.

    Use this to inspect the store records before you write a script.

    Parameters
    ----------
    path
        Path to a file relative to the Blockbuster workspace.
    """
    return (project_dir / path).read_text()


def write_file(path: str, content: str) -> str:
    """
    Write a file in the Blockbuster workspace, overwriting it if it exists.

    Use this to create a script or its output.

    Parameters
    ----------
    path
        Path to a file relative to the Blockbuster workspace.
    content
        The full contents of the file to write.
    """
    (project_dir / path).write_text(content)
    return f"Wrote {path}."


# %%
# STEP 1: The list files tool.
def list_files() -> str:
    """
    List the names of files in the Blockbuster workspace.

    Use this to discover new files before you read or edit them.
    """
    return "\n".join(p.name for p in project_dir.iterdir())


# %%
# STEP 2: The edit file tool.
def edit_file(path: str, old: str, new: str) -> str:
    """
    Replace one exact span of text in a workspace file.

    The existing text must appear exactly once or the tool returns an error.
    Use this to patch a script instead of rewriting it.

    Parameters
    ----------
    path
        Path to a file relative to the Blockbuster workspace.
    old
        The exact existing text to replace.
    new
        The text that replaces it.
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


# %% [markdown]
# **Step 3:** Prepare the agent with its tools.

# %%
chat = ChatPosit(
    model="zai-org/GLM-5.3-Flash",
    system_prompt="""
You are a coding agent for the Last Blockbuster in Bend, Oregon.
Work in the current directory.
When a task needs code, write a Python script for the user to run.
""",
)

# %%
chat.register_tool(read_file)
chat.register_tool(write_file)
chat.register_tool(list_files)
chat.register_tool(edit_file)

# %% [markdown]
# **Step 4:** Put your agent to work.

# %%
chat.chat(
    """
It is time for the renewal drive. Which members have gone quiet?
Build the win-back list as `win-back.csv` by writing `find_lapsed.py`
for me to run from inside the blockbuster folder.
"""
)

# %% [markdown]
# **Step 5:** Your manager found an old register export.

# %%
chat.chat(
    """
The manager found an old register export and dropped it in the folder.
Bring the win-back list up to date.
"""
)

# %% [markdown]
# Inspect the whole conversation, including every tool call.

# %%
chat
