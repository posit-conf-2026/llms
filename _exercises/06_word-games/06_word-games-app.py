import chatlas
from shiny import App, ui
from shinychat import Chat, chat_ui

system_prompt = """
We are playing a word guessing game. You are going to think of a random word.
When you do, write it in an HTML comment so that you can remember it, but the
user can't see it.

Give the user an initial clue and then only answer their questions with yes or
no. When they win, use lots of emojis.
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
