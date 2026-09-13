from pathlib import Path
from typing import Literal

import chatlas
from playsound3 import playsound
from pyhere import here
from shiny import App
from shinychat import Chat, page_chat

# Tools ------------------------------------------------------------------------
SoundChoice = Literal["correct", "incorrect", "new-round", "you-win"]

sound_map: dict[SoundChoice, Path] = {
    "correct": here("data/sounds/smb_coin.wav"),
    "incorrect": here("data/sounds/wilhelm.wav"),
    "new-round": here("data/sounds/victory_fanfare_mono.wav"),
    "you-win": here("data/sounds/smb_stage_clear.wav"),
}


# STEP 1: Document this function so the LLM knows how to use it ----
def play_sound(sound: SoundChoice = "correct") -> str:
    """
    Plays a sound effect.

    Parameters
    ----------
    sound: Which sound effect to play: "correct", "incorrect", "new-round" or
           "you-win". Play the "new-round" sound after the user picks a theme
           for the round. Play the "correct" and "incorrect" sounds when the
           user answers a question correctly or incorrectly, respectively. And
           play the "you-win" sound at the end of a round of questions.

    Returns
    -------
    A confirmation that the sound was played.
    """
    if sound not in sound_map.keys():
        raise ValueError(
            f"sound must be one of {sorted(sound_map.keys())}; got {sound!r}"
        )

    playsound(sound_map[sound])

    return f"The '{sound}' sound was played."


# UI ---------------------------------------------------------------------------

app_ui = page_chat("Quiz Game", id="chat")


def server(input, output, session):
    # Recall: Create the chat client inside the server function so that each
    # user session gets its own chat history.
    client = chatlas.ChatPosit(
        model="claude-haiku-4-5",
        system_prompt=here("_solutions/17_quiz-game-2/prompt.md").read_text(),
    )

    # STEP 2: Register the tool with the chat client ----
    client.register_tool(play_sound)

    _chat = Chat(
        "chat",
        client=client,
        greeting="## 🎉 Welcome to the Quiz Game!\n\nChoose a theme:\n\n- 🔬 Science\n- 🏛️ History\n- 🎬 Movies\n- 🏆 Sports\n- 🎵 Music",
    )


app = App(app_ui, server)
