# Demo conversation script

The prompts used in the recorded conversation (`conversation-export.html`).
Before pasting the first prompt, load the data into your R console so
`listings` exists:

```r
library(readr)
listings <- read_csv("data/airbnb-austin.csv")
```

Then paste the prompts one at a time, waiting for the assistant to finish
each turn.

```
Let's figure out which amenities are most associated with higher reviews scores or higher prices in `listings`
```

The assistant explores the data, then responds with a plan. It may use
packages without loading them individually, which leads to the next turn.

```
use tidyverse packages, but load them individually
```

The assistant redoes the analysis with `library()` calls per package.

```
I think we need to look at more than the top 10 most common amenities to find the ones that are differentiating
```

The assistant widens the analysis beyond the 10 most common amenities and
compares price premiums and rating differences across amenities.
