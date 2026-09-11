# %%
import frontmatter
from _tools import edit_file, list_files, read_file, write_file
from chatlas import ChatPosit
from pyhere import here

# %% [markdown]
# Your agent from `23_agent-2` gets a new ability today: skills.
# A skill is a folder with a SKILL.md file: frontmatter with a name and
# description, then instructions for a job.
# `skills/renewal-letters/SKILL.md` holds the letter-writing instructions.

# %%
skills_dir = here("_exercises/24_skills-1/skills")


# %%
def list_skills(skills_dir):
    skill_files = sorted(skills_dir.rglob("SKILL.md"))
    skill_metadata = [frontmatter.load(path).metadata for path in skill_files]

    return "\n".join(
        f"- {skill['name']}: {skill['description']}" for skill in skill_metadata
    )


# %%
# STEP 1: Document this function so the LLM knows when and how to use it.
def read_skill(skill: str) -> str:
    """____"""
    return (skills_dir / skill / "SKILL.md").read_text()


# %%
# STEP 2: List your skills in the system prompt.
# Add each skill's name and description to the system prompt.
chat = ChatPosit(
    model="zai-org/GLM-5.3-Flash",
    system_prompt=f"""
You are a coding agent for the Last Blockbuster in Bend, Oregon.

Read a skill with the read_skill tool before you do the job it describes.

## Available skills

________
""",
)

# %%
chat.register_tool(read_file)
chat.register_tool(write_file)
chat.register_tool(list_files)
chat.register_tool(edit_file)

# %% [markdown]
# **Step 3:** Register the `read_skill` tool with the chat.

# %%
chat.____(____)

# %% [markdown]
# **Step 4:** Put your agent to work.
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
