# %%
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your agent works in `blockbuster/`, the records for the Last Blockbuster in
# Bend, Oregon. Open the folder and look around before you run this script.

# %%
project_dir = here("_exercises/19_agent-1/blockbuster")


# %%
# STEP 1: Wrap up file reading and writing so the LLM can use them.
#
# pathlib gives us two great methods for reading and writing files:
#
#   * Path.read_text()
#   * Path.write_text()
#
# But we're not going to just give those directly to the LLM! We wrap the
# operations we trust it with into functions and hand those to it as tools.
# For each one, think through:
#
#   1. What inputs do we want from the LLM?
#
#   2. Fill in the function to take action for the LLM.
#
#   3. What text do we send back to the LLM?
def read_file(path: str) -> str:
    path = project_dir / path
    # ____


def write_file(path: str, content: str) -> str:
    path = project_dir / path
    # ____


# %%
# STEP 2: Document each function so the LLM knows when and how to use it.
# Remember: the LLM sees only the docstrings and type hints, not the code.
def read_file(path: str) -> str:
    """
    ____

    Parameters
    ----------
    path
        Path to a file relative to the Blockbuster workspace.
    """
    path = project_dir / path
    return path.read_text()


def write_file(path: str, content: str) -> str:
    """
    ____

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

# %% [markdown]
# **Step 3:** Register both tools with the chat client.

# %%
chat.register_tool(read_file)
chat.register_tool(write_file)

# %% [markdown]
# **Step 4:** Put your agent to work.
#
# Ask the agent to build the win-back list as `win-back.csv`.
# It cannot run code, so it must write `find_lapsed.py` for you to run from
# inside `blockbuster/`.

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
