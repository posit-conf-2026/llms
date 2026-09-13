import tempfile
from pathlib import Path

import chatlas
import matplotlib.pyplot as plt
import numpy as np
import polars as pl
from inspect_ai.dataset import MemoryDataset, Sample
from inspect_ai.model import ChatMessageUser, ContentImage, ContentText
from inspect_ai.scorer import (
    CORRECT,
    INCORRECT,
    Score,
    Target,
    accuracy,
    scorer,
    stderr,
)
from inspect_ai.solver import TaskState
from pydantic import BaseModel
from pyhere import here


class Grade(BaseModel):
    correct: bool
    explanation: str


@scorer(metrics=[accuracy(), stderr()])
def model_graded_qa_posit():
    async def score(state: TaskState, target: Target) -> Score:
        answer = state.output.completion if state.output else ""
        judge = chatlas.ChatPosit(model="moonshotai/Kimi-K3")
        grade = await judge.chat_structured_async(
            f"""
Grade the response against the criterion.

Question:
{state.input_text}

Criterion:
{target.text}

Response:
{answer}
""",
            data_model=Grade,
        )

        return Score(
            value=CORRECT if grade.correct else INCORRECT,
            explanation=grade.explanation,
        )

    return score


def make_plot_cases(prompts):
    plot_files = make_plot_files()
    plot_targets = {
        "trend": (
            "The response says that the points show a clear negative relationship: "
            "as weight increases, fuel economy decreases. "
            "It bases this conclusion on the plotted points."
        ),
        "noise": (
            "The response says that the points do not show a meaningful relationship "
            "or trend. It does not infer a relationship from the title or axis labels."
        ),
    }

    return MemoryDataset(
        [
            Sample(
                id=f"{prompt_name}-{plot_name}",
                input=[
                    ChatMessageUser(
                        content=[
                            ContentText(text=prompt),
                            ContentImage(image=str(plot_file)),
                        ]
                    )
                ],
                target=plot_targets[plot_name],
                metadata={"prompt_name": prompt_name, "plot_name": plot_name},
            )
            for prompt_name, prompt in prompts.items()
            for plot_name, plot_file in plot_files.items()
        ],
        name="plot-prompt-eval",
    )


def make_plot_files():
    mtcars = pl.read_csv(here("data/mtcars.csv"))
    noise = make_noise_points()
    plot_dir = Path(tempfile.mkdtemp(prefix="plot-eval-"))
    plot_files = {
        "trend": plot_dir / "trend.png",
        "noise": plot_dir / "noise.png",
    }

    fig, ax = plt.subplots(figsize=(7, 5))
    ax.scatter(mtcars["wt"], mtcars["mpg"], color="steelblue", s=45)
    ax.set(
        title="MPG vs Weight",
        xlabel="Weight (1000 lb)",
        ylabel="Miles per Gallon (mpg)",
    )
    fig.savefig(plot_files["trend"], dpi=150, bbox_inches="tight")
    plt.close(fig)

    fig, ax = plt.subplots(figsize=(7, 5))
    ax.scatter(noise[:, 0], noise[:, 1], color="steelblue", s=45)
    ax.set(
        title="MPG vs Weight",
        xlabel="Weight (1000 lb)",
        ylabel="Miles per Gallon (mpg)",
    )
    fig.savefig(plot_files["noise"], dpi=150, bbox_inches="tight")
    plt.close(fig)

    return plot_files


def make_noise_points():
    rng = np.random.default_rng(2026)
    g = 5
    u = (np.arange(1, g + 1) - 0.5) / g
    xx, yy = np.meshgrid(u, u)
    grid = np.column_stack([xx.ravel(), yy.ravel()])
    eps = 1 / (2 * np.sqrt(32))
    return np.clip(grid + rng.uniform(-eps, eps, size=grid.shape), 0, 1)
