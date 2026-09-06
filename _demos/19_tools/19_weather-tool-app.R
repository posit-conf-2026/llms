library(shiny)
library(bslib)
library(ellmer)
library(shinychat)
library(weathR)

get_weather <- tool(
  \(lat, lon) {
    # Tools must return a string, JSON, or Content object.
    # ellmer 0.5.0 no longer auto-converts data frames.
    forecast <- sf::st_drop_geometry(weathR::point_forecast(lat, lon))
    jsonlite::toJSON(forecast, auto_unbox = TRUE)
  },
  name = "get_weather",
  description = "Get forecast data for a specific latitude and longitude.",
  arguments = list(
    lat = type_number("Latitude of the location."),
    lon = type_number("Longitude of the location.")
  )
)

ui <- page_fillable(
  chat_mod_ui("chat")
)

server <- function(input, output, session) {
  client <- ellmer::chat_posit(model = "zai-org/GLM-5.3-Flash")
  client$register_tool(get_weather)

  chat_mod_server("chat", client)
}

shinyApp(ui, server)
