# %%
import frontmatter
from _tools import edit_file, list_files, read_file, write_file
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your skills-wired agent from `21_skills-1` is back, but its skill is a bad
# first draft.
# Open `skills/renewal-letters/SKILL.md` before you continue.
# The skills folder also holds three other skills the agent can choose from.

# %% [markdown]
# **Step 1:** Fix the skill.
#
# Start at the top of `skills/renewal-letters/SKILL.md` and work through these
# questions one at a time:
#
# 1. Read only the description.
# If that were all the agent saw before choosing a skill, what would it know
# to do?
#
# 2. When will the agent read the first two sentences in the body?
#
# 3. Read the rest of the body beside the store files.
# Which parts tell the agent something it cannot already find elsewhere?
#
# 4. Where and how does the skill describe the process the agent should
# follow?
# Is the process clear?
# Is there room for interpretation or confusion?

# %%
skills_dir = here("_exercises/22_skills-2/skills")


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
# We've written `list_skills()` for you:
# it reads each skill folder's SKILL.md frontmatter and returns a
# `name: description` line per skill.
# Run it to see what it produces, then check the system prompt below.


# %%
def list_skills(skills_dir):
    skill_files = sorted(skills_dir.rglob("SKILL.md"))
    skill_metadata = [frontmatter.load(path).metadata for path in skill_files]

    return "\n".join(
        f"- {skill['name']}: {skill['description']}" for skill in skill_metadata
    )


list_skills(skills_dir)

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
# **Step 2:** Put your agent to work.
#
# After you fix the skill, re-run the letter task from `21_skills-1`.

# %%
chat.chat(
    "Draft renewal letters for the top three members on lapsed.csv. "
    "Save one file for each member in letters/drafts/."
)

# %% [markdown]
# Inspect the whole conversation, including every tool call.

# %%
chat
