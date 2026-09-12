# %%
import frontmatter
from _tools import edit_file, list_files, read_file, write_file
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your agent from `20_agent-2` gets a new ability today: skills.
# A skill is a folder with a SKILL.md file: frontmatter with a name and
# description, then instructions for a job.
# `skills/renewal-letters/SKILL.md` holds the letter-writing instructions.

# %%
skills_dir = here("_solutions/21_skills-1/skills")

# %% [markdown]
# **Step 1:** Document the `read_skill` tool.
#
# Read `read_skill()` below, then describe it for the LLM.
# Remember: the LLM sees only your docstring, not the Python code.


# %%
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


# %% [markdown]
# **Step 2:** List your skills.
#
# We've written `list_skills()` for you:
# it reads each skill folder's SKILL.md frontmatter and returns a
# `name: description` line per skill. Run it to see what it produces,
# then use it in the system prompt below.


# %%
def list_skills(skills_dir):
    skill_files = sorted(skills_dir.rglob("SKILL.md"))
    skill_metadata = [frontmatter.load(path).metadata for path in skill_files]

    return "\n".join(
        f"- {skill['name']}: {skill['description']}" for skill in skill_metadata
    )


list_skills(skills_dir)

# %% [markdown]
# Add each skill's name and description to the system prompt.

# %%
chat = ChatPosit(
    model="zai-org/GLM-5.3-Flash",
    system_prompt=f"""
You are a coding agent for the Last Blockbuster in Bend, Oregon.

Read a skill with the read_skill tool before you do the job it describes.

## Available skills

{list_skills(skills_dir)}
""",
)

# %%
chat.register_tool(read_file)
chat.register_tool(write_file)
chat.register_tool(list_files)
chat.register_tool(edit_file)

# Register the `read_skill` tool.
chat.register_tool(read_skill)

# %% [markdown]
# **Step 3:** Put your agent to work.
#
# Draft renewal letters for the top three members on `lapsed.csv`.
# Save one file for each member in `letters/drafts/`.
# Watch for the agent to read the skill before it starts drafting.

# %%
chat.chat(
    "Draft renewal letters for the top three members on lapsed.csv. "
    "Save one file for each member in letters/drafts/."
)

# %% [markdown]
# Inspect the whole conversation, including every tool call.

# %%
chat
