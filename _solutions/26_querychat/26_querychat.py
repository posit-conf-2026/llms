# Setup ------------------------------------------------------------------------
import pandas as pd
from chatlas import ChatPosit
from pyhere import here
from querychat import QueryChat

# Load the data
airbnb_data = pd.read_csv(here("data/airbnb-austin.csv"))

# QueryChat turns a data frame into an app with chat, data, and SQL views.
qc = QueryChat(
    airbnb_data,
    "airbnb_data",
    client=ChatPosit(),
    greeting="Ask me about Austin Airbnb listings.",
    data_dict=here("data/airbnb-austin_data-dict.yaml"),
)

app = qc.app()

# Your turn -------------------------------------------------------------------

# 1. Ask: Which neighborhood has the most private rooms?
# 2. Open the data drawer and select Show Query to inspect the generated SQL.
# 3. Ask a follow-up question about the private rooms in that neighborhood.
# 4. Uncomment `data_dict`, restart the app, and ask: Among private rooms, which
#    property types are most common?
