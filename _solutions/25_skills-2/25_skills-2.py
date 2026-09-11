# %%
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Manager: What did you change in the first draft?
# Author: I moved the use-it and do-not-use-it sentences into the description.
# Manager: Why did you delete the policy and campaign paragraphs?
# Author: The agent can read those facts in the store files.
# Manager: What happened to the conflicting and generic writing advice?
# Author: I deleted it and kept the existing voice, letter checklist, filename
# rule, tier incentives, and promises caveat.

# %%
project_dir = here("_solutions/25_skills-2/blockbuster")
skills_dir = here("_solutions/25_skills-2/skills")


# %%
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


def read_skill(skill: str) -> str:
    """
    Read the full instructions for a listed skill.

    Call this before you do the job the skill describes.

    Parameters
    ----------
    skill
        Name of the skill to read, such as "renewal-letters".
    """
    return (skills_dir / skill / "SKILL.md").read_text()


# %%
chat = ChatPosit(
    model="zai-org/GLM-5.3-Flash",
    system_prompt="""
You are a coding agent for the Last Blockbuster in Bend, Oregon.

You have one skill: 'renewal-letters' drafts a renewal letter for a lapsed Last
Blockbuster member. Read it with the read_skill tool before you draft a renewal
letter.
""",
)

# %%
chat.register_tool(read_file)
chat.register_tool(write_file)
chat.register_tool(list_files)
chat.register_tool(edit_file)
chat.register_tool(read_skill)

# %%
chat.chat(
    "Draft renewal letters for the top three members on lapsed.csv. "
    "Save one file for each member in letters/drafts/."
)

# %% [markdown]
# Inspect the whole conversation, including every tool call.

# %%
chat
