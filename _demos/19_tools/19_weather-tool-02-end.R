# ---- ✦ I can get the weather with R! ✦ ----
library(weathR)

posit_conf <- list(lat = 29.7515551, lon = -95.3606597)

weathR::point_forecast(posit_conf$lat, posit_conf$lon)


# ---- ⚒️ Let's turn this into a tool 🛠️ ----
library(ellmer)

ellmer::create_tool_def(weathR::point_forecast, verbose = TRUE)

get_weather <- tool(
  \(lat, lon) {
    # Tools must return a string, JSON, or Content object.
    # ellmer 0.5.0 no longer auto-converts data frames.
    forecast <- sf::st_drop_geometry(weathR::point_forecast(lat, lon))
    jsonlite::toJSON(forecast, auto_unbox = TRUE)
  },
  name = "point_forecast",
  description = "Get forecast data for a specific latitude and longitude.",
  arguments = list(
    lat = type_number("Latitude of the location."),
    lon = type_number("Longitude of the location.")
  )
)

# The tool is callable!
get_weather(posit_conf$lat, posit_conf$lon)

# ---- 🧰 Teach an LLM that we have this tool ----
chat <- chat_posit(model = "zai-org/GLM-5.3-Flash", echo = "output")

# Register the tool with the chatbot
chat$register_tool(get_weather)

chat$chat("What should I wear to posit::conf(2026) in Houston?")
