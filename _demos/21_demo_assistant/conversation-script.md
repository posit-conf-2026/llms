# Demo conversation script

The exact prompts from the recorded conversation (`conversation-export.html`),
with what to expect from each turn.

The recording used last year's Asheville data. Run it against Austin instead:
`data/airbnb-austin.csv`.

## Before you start

Load the data into the R console so `listings` exists:

```r
library(readr)
listings <- read_csv("data/airbnb-austin.csv")
```

Keep the console visible while the assistant works.
It runs code in that session, so the class sees each result as it lands.

## Turn 1: open-ended question

```
Let's figure out which amenities are most associated with higher reviews scores or higher prices in `listings`
```

The assistant inspects the data, then plans out loud: parse the amenities
column, count them, and relate them to `score_rating` and `price`.
Narrate how it chooses the next step from the result of the last one.

## Turn 2: correct its approach

```
use tidyverse packages, but load them individually
```

The recorded run jumped ahead with unattached `dplyr::` calls.
This prompt pulls it back and redoes the analysis with explicit `library()`
calls. A good moment to point out that you can steer the loop at any turn,
not just at the start.

## Turn 3: push past the obvious

```
I think we need to look at more than the top 10 most common amenities to find the ones that are differentiating
```

The first pass ranked only the 10 most common amenities, which are things
every listing has. The assistant widens the search and surfaces amenities
with real price premiums and rating differences.
Narrate the shift from "common amenities" to "differentiating amenities."
