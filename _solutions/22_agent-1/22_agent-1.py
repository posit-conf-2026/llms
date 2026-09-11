# %%
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.

# %%
project_dir = here("_solutions/22_agent-1/blockbuster")


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
chat = ChatPosit(
    model="zai-org/GLM-5.3-Flash",
    system_prompt="""
You are a coding agent for the Last Blockbuster in Bend, Oregon.
Start by reading README.md and every store document it names.
The initial workspace has members.csv, rentals.csv, and dues.csv.
Do not guess paths that are not in those records.
Do not read rentals.csv with read_file because it has 1,500 rows.
Write a script that reads the rental log instead.
Write the first script for only the files that exist now.
Do not add support for future exports until the user asks you to update it.
You cannot run code or use tools beyond the ones registered for you.
When a task needs code, write a Python script for the user to run.
Write scripts with paths relative to the workspace because the user runs them
from inside the blockbuster folder.
Do not say a data task is complete until you have written the script.
""",
)

# %%
chat.register_tool(read_file)
chat.register_tool(write_file)

# %%
chat.chat(
    "It is time for the renewal drive. Which members have gone quiet? "
    "Build the win-back list as win-back.csv by writing find_lapsed.py for me "
    "to run from inside the blockbuster folder."
)

# %% [markdown]
# Inspect the whole conversation, including every tool call.

# %%
chat
