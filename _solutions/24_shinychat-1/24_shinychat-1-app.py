# %%
from _agent import prep_blockbuster_agent
from chatlas import ChatPosit
from pyhere import here
from shiny import App
from shinychat import Chat, chat_greeting, page_chat

# %%
activity_dir = here("_solutions/24_shinychat-1")
project_dir = activity_dir / "blockbuster"
skills_dir = activity_dir / "skills"

# %%
# STEP 1 - Create a greeting ----
# Add a welcome message and three suggestion cards for the renewal desk.
greeting = """## Welcome to the renewal desk

Choose a starting point, or write your own request.

* <span class="suggestion submit">Draft renewal letters for the top three lapsed members.</span>
* <span class="suggestion submit">List the draft letters already in the workspace.</span>
* <span class="suggestion submit">Explain the renewal-letter skill.</span>
"""

# %%
app_ui = page_chat(
    "Blockbuster renewal assistant",
    id="chat",
    greeting=chat_greeting(greeting),
    placeholder="Ask about the renewal campaign...",
)


def server(input, output, session):
    client = ChatPosit(model="zai-org/GLM-5.3-Flash")
    # Adds the Blockbuster system prompt, tools, and skills from the last exercise.
    prep_blockbuster_agent(client, project_dir, skills_dir)

    # Connect the app to our Blockbuster agent client
    Chat("chat", client=client)


app = App(app_ui, server)
