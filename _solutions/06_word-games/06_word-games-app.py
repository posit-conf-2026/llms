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
    chat_ui("chat", placeholder="""Say "Let's play" to get started!""")
)


def server(input, output, session):
    client = chatlas.ChatPosit(system_prompt=system_prompt)
    chat = Chat("chat", client=client)


app = App(app_ui, server)
