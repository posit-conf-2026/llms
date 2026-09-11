# Demo: Posit Assistant as an agent

Posit Assistant explores a dataset, decides what to do next, and acts — the agent loop from the slides, running live.

If the live demo fails, open `conversation-export.html` to walk through a recorded conversation instead.
The exact prompts from that recording are below.

## Set up

1. Open the workshop project in Positron and sign in to Posit Assistant with your Posit AI Pass account.
1. Ask everyone to do the same. They explore on their own in a moment.
1. Open `data/airbnb-austin.csv` in the viewer so the class can see the starting point.

## Instructor: start the conversation

Paste this prompt into Posit Assistant:

```
I'm thinking of opening an Airbnb in Austin, TX and starting to do some basic market research. Let's look at `data/airbnb-austin.csv`, do some basic work to familiarize ourselves with the data, and then find interesting patterns. Recommend where and what kind of Airbnb I should open.
```

While the assistant works, narrate the loop:

- It reads the data, chooses an analysis, and runs code — then decides the next step from the result of the last one.
- Running code is both a read tool and a write tool: it observes the data and changes the project.
- Point out every permission prompt. Ask: what makes this step safe enough to approve?

## Fallback: the recorded conversation

Load the data in the R console first, so `listings` exists:

```r
library(readr)
listings <- read_csv("data/airbnb-austin.csv")
```

Then paste these prompts one at a time, waiting for the assistant to finish each turn.

1. `Let's figure out which amenities are most associated with higher reviews scores or higher prices in \`listings\``
2. `use tidyverse packages, but load them individually`
3. `I think we need to look at more than the top 10 most common amenities to find the ones that are differentiating`

## Everyone: your turn

Run the same prompt yourself, then take the exploration further.

Some ideas:

- What amenities are most associated with higher review scores or higher prices?
- How do minimum night requirements impact occupancy?
- Is the number of listings in a neighborhood related to property success metrics?

Finish by asking the assistant to write things down:

```
Write a report summarizing our calculations and findings, and save it as `airbnb-report.md`.
```

## Discussion

- What tools did the assistant use? Which observed the world, and which changed it?
- Where did the assistant ask for permission, and where did it act on its own?
- What would you do differently if the data were production data, or the task spent money?
