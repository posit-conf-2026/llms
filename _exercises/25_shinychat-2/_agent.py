from pathlib import Path

import frontmatter
from chatlas import ChatPosit


def list_skills(skills_dir: Path) -> str:
    skill_files = sorted(skills_dir.rglob("SKILL.md"))
    skills = [frontmatter.load(path).metadata for path in skill_files]
    return "\n".join(
        f"- {skill['name']}: {skill['description']}" for skill in skills
    )


def prep_blockbuster_agent(
    client: ChatPosit,
    project_dir: Path,
    skills_dir: Path,
) -> None:
    def read_file(path: str) -> str:
        """Read the full contents of a file in the Blockbuster workspace."""
        return (project_dir / path).read_text()

    def write_file(path: str, content: str) -> str:
        """Write a file in the Blockbuster workspace, overwriting it if it exists."""
        full_path = project_dir / path
        full_path.parent.mkdir(parents=True, exist_ok=True)
        full_path.write_text(content)
        return f"Wrote {path}."

    def list_files() -> str:
        """List files in the Blockbuster workspace, including draft letters."""
        return "\n".join(
            str(path.relative_to(project_dir))
            for path in sorted(project_dir.rglob("*"))
            if path.is_file()
        )

    def edit_file(path: str, old: str, new: str) -> str:
        """Replace one exact span of text in a Blockbuster workspace file."""
        full_path = project_dir / path
        content = full_path.read_text()
        matches = content.count(old)

        if matches == 0:
            raise ValueError(f"Could not find the text to replace in {path}.")
        if matches != 1:
            raise ValueError(f"Expected one exact match in {path}, but found {matches}.")

        full_path.write_text(content.replace(old, new))
        return f"Edited {path}."

    def read_skill(skill: str) -> str:
        """Read the full instructions for a listed skill before doing its job."""
        return (skills_dir / skill / "SKILL.md").read_text()

    system_prompt = f"""
You are a coding agent for the Last Blockbuster in Bend, Oregon.

Read a skill with the read_skill tool before you do the job it describes.
For a new renewal letter, list letters/drafts first and write the next version as
letters/drafts/<member-name>-vN.md.

## Available skills

{list_skills(skills_dir)}
"""

    client.system_prompt = system_prompt
    for tool in (read_file, write_file, list_files, edit_file, read_skill):
        client.register_tool(tool)
