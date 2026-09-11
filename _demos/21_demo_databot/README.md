# Demo: Posit Assistant as an agent

Posit Assistant explores a dataset, decides what to do next, and acts — the agent loop from the slides, running live.

If the live demo fails, open `conversation-export.html` to walk through a recorded conversation instead.

## Set up

1. Open the workshop project in Positron and sign in to Posit Assistant with your Posit AI Pass account.
1. Ask everyone to do the same. They explore on their own in a moment.
1. Open `data/airbnb-asheville.csv` in the viewer so the class can see the starting point.

## Instructor: start the conversation

Paste this prompt into Posit Assistant:

```
Let's look at `data/airbnb-asheville.csv`, do some basic work to familiarize ourselves with the data, and then find interesting patterns that would be relevant to someone looking to open an Airbnb in Asheville, NC.
```

While the assistant works, narrate the loop:

- It reads the data, chooses an analysis, and runs code — then decides the next step from the result of the last one.
- Running code is both a read tool and a write tool: it observes the data and changes the project.
- Point out every permission prompt. Ask: what makes this step safe enough to approve?

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
