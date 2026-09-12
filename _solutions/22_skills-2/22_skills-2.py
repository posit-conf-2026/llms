# %%
import frontmatter
from _tools import edit_file, list_files, read_file, write_file
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
skills_dir = here("_solutions/22_skills-2/skills")


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
