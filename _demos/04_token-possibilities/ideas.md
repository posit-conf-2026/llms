The goal of this exercise is to explore how the words you use in your prompt change the possible responses from a Large Language Model (LLM).

We start with a specific, but open-ended prompt for a limerick about a cat.

```markdown
Write a funny limerick about a cat.
```

Try replacing `cat` with `animal`.

```markdown
Write a funny limerick about an animal.
```

How does that change the LLM's response?
Try adding adjectives or other modifiers – `barn animal`, `zoo animal`, `funny animal` – to see how they affect the output.

***

## Other prompt ideas to explore

Try these examples to explore how LLMs navigate between certainty and ambiguity based on available context.

### High Ambiguity Examples

- "The bank..." (financial institution or riverside?)
- "She saw a bat..." (animal or sports equipment?)
- "I need to get a prescription for my..." (many medical possibilities)
- "Please pass the..." (countless objects could follow)
- "The doctor examined the patient's..." (multiple body parts possible)

### Context Shifts Probability

- "I'm going to the bank to..." (now likely financial)
- "I'm going to the bank to fish..." (now likely riverside)
- "The pitcher threw the bat..." (sports context established)
- "The cave was full of sleeping bat..." (animal context established)
- "Time flies like an..." (arrow? airplane? hour?)
- "Time flies like an arrow; fruit flies like a..." (banana becomes highly probable)

### Probability Steered by Specificity

- "The capital of France is..." (very high certainty for "Paris")
- "The chemical symbol for gold is..." (very high certainty for "Au")
- "To be or not to be, that is the..." (extremely high certainty for "question")
- "I woke up this morning feeling..." (many plausible completions)
- "In a world where..." (extremely open-ended)

### Contextual Collocations

- "Strong..." (coffee? winds? opinions? person?)
- "Strong tea and..." (likely food-related completions)
- "The heavy..." (weight? rain? traffic? burden?)
- "She couldn't bear the heavy..." (psychological interpretation more likely)

***

# Where does the answer get decided?

The examples above look at one token at a time.
But whole *answers* can also be uncertain — and research on LLM uncertainty
([Forking Fast, Bigelow et al. 2026](https://arxiv.org/abs/2608.19611)) finds
that a response is usually decided at a few sharp **forking points**, not
gradually across the whole reply.

Before a forking point the final answer is genuinely undecided.
After it, the outcome is largely locked in — even if the rest of the response
reads long, fluent, and confident.

## Forking questions to try

These questions have two defensible readings, so different generations can
land on different answers.
Submit the same prompt a few times and watch the token probabilities for the
committing words.

- "A wooden fence has posts every 2 meters along a 30-meter stretch. How many posts are needed?" (15 vs. 16)
- "A conference runs from the 14th to the 17th. How many days is the conference?" (4 vs. 3)
- "Is a hot dog a sandwich? Your first word must be YES or NO, then justify in one sentence."
- "Is a tomato a fruit or a vegetable?" (botanical vs. culinary)

Then remove the fork and submit again.
Watch the answer distribution collapse to a single confident response —
the fork lives in the prompt, not in the model.

- "...with a post at each end."
- "A conference runs from the 14th (check-in) through the 17th (check-out). How many nights is the stay?"

## One wrong, not two defensible

Not every spread of answers is ambiguity.
In these questions one answer is simply wrong — the distribution reflects the
model's miss rate, not two valid readings.

- "How many animals of each kind did Moses take on the ark?" (It was Noah.)
- "How many R's are in 'strawberry'?"

That distinction matters in practice:
for an interpretive fork, disambiguate the prompt.
For a detection fork, verify the answer — no rewording saves you.

## A single response is one sample

Re-rolling a prompt and getting a different answer doesn't mean the model is
erratic.
Each response is a sample from a stable underlying distribution, and the
jaggedness across a few samples is ordinary sampling noise.
Ask several times and the real picture emerges — which is also why
"ask it three times and take the majority" works as more than a hack.
