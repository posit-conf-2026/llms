import random

import chatlas
from pyhere import here
from shiny import App, ui
from shinychat import Chat, chat_ui

# Picks a random word for the model to keep secret from a list.
word = random.choice(here("data/words.txt").read_text().splitlines())

system_prompt = f"""
We are playing a word guessing game. The secret word is "{word}".

Never say the secret word out loud. Give the user an initial clue and then
only answer their questions with yes or no. When they win, use lots of emojis.
"""

app_ui = ui.page_fillable(
    # Step 1: Add the chat UI component
    ____
)


def server(input, output, session):
    # Step 2: Initialize the chat client with the system prompt
    client = chatlas.ChatPosit(____=____)
    # Step 3: Connect the chat UI to the chat client
    chat = ____


app = App(app_ui, server)
