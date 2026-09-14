import chatlas
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


class Grade(BaseModel):
    correct: bool
    explanation: str


@scorer(metrics=[accuracy(), stderr()])
def model_graded_qa_posit():
    async def score(state: TaskState, target: Target) -> Score:
        answer = state.output.completion if state.output else ""
        judge = chatlas.ChatPosit()
        grade = await judge.chat_structured_async(
            f"""
Grade the response against the criterion.
The response passes only if it satisfies every part of the criterion.
Do not excuse a missing fact or a format violation.

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
