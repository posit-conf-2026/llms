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
skills_dir = here("_solutions/24_skills-1/skills")


def list_skills(skills_dir):
    skill_files = sorted(skills_dir.rglob("SKILL.md"))
    skill_metadata = [frontmatter.load(path).metadata for path in skill_files]

    return "\n".join(
        f"- {skill['name']}: {skill['description']}" for skill in skill_metadata
    )


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
    system_prompt=f"""
You are a coding agent for the Last Blockbuster in Bend, Oregon.

Available skills:
{list_skills(skills_dir)}

Read a skill with the read_skill tool before you do the job it describes.
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
