# Case data for the evals exercise, read from a shared JSON file so the R
# and Python versions stay in sync. Each case plants a subtle data-quality
# artifact in the prompt, and `target` spells out the artifact and what
# counts as flagging it.

import json
from pathlib import Path

from inspect_ai.dataset import MemoryDataset, Sample


def _repo_root():
    path = Path(__file__).resolve()
    for parent in [path, *path.parents]:
        if (parent / "pyproject.toml").exists():
            return parent
    raise FileNotFoundError("Could not locate the repository root")


def bluff_mini_cases():
    cases_file = _repo_root() / "data" / "bluff-mini-cases.json"
    cases = json.loads(cases_file.read_text())

    return MemoryDataset(
        [
            Sample(id=case["id"], input=case["input"], target=case["target"])
            for case in cases
        ],
        name="bluff-mini",
    )
