# Demo: weather tool

A minimal app where the LLM can call a `get_weather()` tool.
The R demo is a script that starts from `16_weather-tool-01-start.R` and ends at `16_weather-tool-02-end.R`, then comes together in a Shiny app (`16_weather-tool-app.R`).
The Python demo starts from `16_weather-tool-01-start.py` and ends at `16_weather-tool-02-end.py`, then comes together in a Shiny app (`16_weather-tool-app.py`).

## Going further

Tool results can carry their own display metadata — a title and icon — which shinychat renders in the chat UI.
See the `extra$display` / `extra["display"]` field on a tool result:

- R: [ellmer: `ContentToolResult`](https://ellmer.tidyverse.org/reference/Content.html)
- Python: [chatlas: `ContentToolResult`](https://posit-dev.github.io/chatlas/reference/types.ContentToolResult.html)
- [Tool calling UI in shinychat](https://shiny.posit.co/blog/posts/shinychat-tool-ui/) — how tool requests and results are rendered in the chat (R and Python)
