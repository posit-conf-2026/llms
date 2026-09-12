# %%
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.

# %%
project_dir = here("_solutions/21_agent-1/blockbuster")


# %%
# STEP 1: Wrap up file reading and writing so the LLM can use them.
#
# 1. Inputs: read_file takes the path the LLM wants to inspect;
#    write_file takes a path and the full contents to put there.
# 2. Work: resolve the path into the workspace (project_dir / path) and
#    perform the file operation with pathlib.
# 3. Outputs: read_file returns the file contents; write_file returns a
#    short confirmation because the LLM learns from what we return.
def read_file(path: str) -> str:
    """
    Read the full contents of a file in the Blockbuster workspace.

    Use this to inspect the store records before you write a script.

    Parameters
    ----------
    path
        Path to a file relative to the Blockbuster workspace.
    """
    path = project_dir / path
    return path.read_text()


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
    path = project_dir / path
    path.write_text(content)
    return f"Wrote {path}."


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

# %%
chat.chat(
    """
It is time for the renewal drive. Which members have gone quiet?
Build the win-back list as `win-back.csv` by writing `find_lapsed.py`
for me to run from inside the blockbuster folder.
"""
)

# %% [markdown]
# Inspect the whole conversation, including every tool call.

# %%
chat
