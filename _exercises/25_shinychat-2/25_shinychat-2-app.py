# %%
from pathlib import Path

from _agent import prep_blockbuster_agent
from chatlas import ChatPosit
from pyhere import here
from shiny import App, reactive, ui
from shinychat import Chat, chat_drawer, chat_greeting, page_chat

# %%
activity_dir = here("_exercises/25_shinychat-2")
project_dir = activity_dir / "blockbuster"
skills_dir = activity_dir / "skills"
drafts_dir = project_dir / "letters" / "drafts"

# %%
app_ui = page_chat(
    "Blockbuster renewal assistant",
    id="chat",
    greeting=chat_greeting(
        "## Welcome to the renewal desk\n\nDraft letters, then review them in the drawer."
    ),
    placeholder="Ask about the renewal campaign...",
    drawer=chat_drawer(
        ui.input_select("letter", "Draft", choices=[]),
        ui.input_code_editor(
            "letter_content",
            label="Letter",
            language="markdown",
            height="500px",
        ),
        ui.input_action_button("save_letter", "Save letter"),
        title="Letter drafts",
        open=False,
    ),
)


def server(input, output, session):
    # STEP 1 - Show a draft ----
    # Let the model update the app to show a specific draft letter in the drawer.
    def show_letter(path: str) -> str:
        """Open a draft renewal letter in the app's letter drawer."""
        filename = Path(path).name
        files = [path.name for path in sorted(drafts_dir.glob("*.md"))]

        if filename not in files:
            # What should we do with an invalid file name?
            # _____

        # Update the draft picker to select `filename`.
        # Open the chat drawer.
        # Return a short message confirming the opened draft.
        return "____"

    client = ChatPosit(model="zai-org/GLM-5.3-Flash")
    client.register_tool(show_letter)

    # Adds the Blockbuster system prompt, tools, and skills from the last exercise.
    prep_blockbuster_agent(client, project_dir, skills_dir)

    # Connect the app to our Blockbuster agent client
    chat = Chat("chat", client=client)  # noqa: F841

    # Drawer synchronization ----
    @reactive.calc
    def draft_files():
        reactive.invalidate_later(1, session=session)
        return [path.name for path in sorted(drafts_dir.glob("*.md"))]

    @reactive.effect
    def _():
        files = draft_files()
        selected = input.letter() if input.letter() in files else None
        ui.update_select("letter", choices=files, selected=selected or (files[0] if files else None))

    @reactive.effect
    @reactive.event(input.letter)
    def _():
        if input.letter():
            ui.update_code_editor(
                "letter_content",
                value=(drafts_dir / input.letter()).read_text(),
            )

    @reactive.effect
    @reactive.event(input.save_letter)
    def _():
        if input.letter():
            (drafts_dir / input.letter()).write_text(input.letter_content())


app = App(app_ui, server)
