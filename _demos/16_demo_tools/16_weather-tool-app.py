# ---- ✦ Weather tool, in a Shiny app ✦ ----
import NWS

import chatlas
from shiny import App, ui
from shinychat import Chat, chat_ui

NWS.InitiateAPI("posit::conf(2026)", "conf@posit.co")


def get_weather(lat: float, lon: float):
    """
    Get forecast data for a specific latitude and longitude.

    Parameters
    ----------
    lat : str
        Latitude of the location.
    lon : str
        Longitude of the location.
    """
    return NWS.GetCurrentForecast(lat, lon)


app_ui = ui.page_fillable(chat_ui("chat"))


def server(input, output, session):
    chat_client = chatlas.ChatPosit(model="zai-org/GLM-5.3-Flash")
    chat_client.register_tool(get_weather)

    Chat("chat", client=chat_client)


app = App(app_ui, server)
