# %%
import chatlas

# %% [markdown]
# [raghilda](https://posit-dev.github.io/raghilda/) is the Python counterpart
# to `ragnar`: it turns a pile of documents into a searchable knowledge store.
# We'll point it at the markdown files from the
# [Polars Cookbook](https://github.com/escobar-west/polars-cookbook), which
# live in `data/polars-cookbook`.
#
# The pipeline has three steps. `read_as_markdown()` reads each file as
# markdown. `MarkdownChunker()` splits each file into chunks, and this is where
# you have the most control over what content is grouped together for embedding
# and later retrieval. Finally, `store.upsert()` inserts each chunk into a
# DuckDB database, sending the chunk text to the embedding provider on the way
# in. raghilda stores the embedding alongside the original text of the chunk.
#
# Embeddings are served by LM Studio (https://lmstudio.ai/), which exposes an
# OpenAI-compatible API on localhost. Make sure LM Studio is running with the
# text-embedding-nomic-embed-text-v2-moe model loaded:
# https://huggingface.co/nomic-ai/nomic-embed-text-v2-moe-GGUF
# %%
from pyhere import here
from raghilda.chunker import MarkdownChunker
from raghilda.embedding import EmbeddingOpenAI
from raghilda.read import read_as_markdown
from raghilda.store import DuckDBStore

embed = EmbeddingOpenAI(
    model="text-embedding-nomic-embed-text-v2-moe",
    base_url="http://localhost:1234/v1",
    api_key="lm-studio",
)

store_location = here("_solutions/51_rag/polars_cookbook.raghilda.duckdb")

store = DuckDBStore.create(
    store_location,
    title="Polars Cookbook",
    # Need to start over? Set `overwrite = True`.
    # overwrite = True,
    embed=embed,
)

chunker = MarkdownChunker()

cookbook_dir = here("data/polars-cookbook")
for file in sorted(cookbook_dir.glob("*.md")):
    document = read_as_markdown(str(file))
    chunked_document = chunker.chunk(document)
    store.upsert(chunked_document)

store.build_index()

# %% [markdown]
# Now that the store is on disk, which chunks surface for a given question?
# Connect to the store with `DuckDBStore.connect()`. raghilda remembers the
# embedding provider used to build the store, so you don't need to configure
# it again.
#
# Next, write `retrieve_polars_knowledge()`, the function the LLM will call as
# a tool. The docstring is sent to the model as the tool description, so write
# it for the LLM: be specific about when the tool should be used and what the
# `query` should contain. Tool results are sent to the model as text, so we
# return JSON. It preserves structure and lets the model parse the results
# without any extra work. We also include the `origin` of each chunk, the file
# it came from, so the model can tell the user where it found the material.

# %%
import json

store = DuckDBStore.connect(store_location, read_only=True)


def retrieve_polars_knowledge(query: str, num_results: int = 5) -> str:
    """
    Search the Polars Cookbook for relevant content.

    Use this tool when the user asks about polars syntax, such as selecting
    columns, filtering rows, grouping, or aggregating data.

    Parameters
    ----------
    query : str
        A description of what to look for.
    num_results : int
        The number of relevant passages to return (default of 5).
    """
    chunks = store.retrieve(query, top_k=num_results, deoverlap=True)
    return json.dumps(
        [{"text": chunk.text, "source": chunk.origin} for chunk in chunks]
    )


# %% [markdown]
# This implementation retrieves the 5 most relevant chunks for the query. You
# can change the number of results with the `num_results` parameter. There's no
# magic number, but you may want to increase it if the retrieved content is
# too sparse or not relevant enough.
#
# Let's try it out now with a task:

# %%
task = """
How do I find all rows in a DataFrame which have the max value for count column, after grouping by ['Sp','Mt'] columns?

Example 1: the following DataFrame, which I group by ['Sp','Mt']:

```
Sp Mt Value count
0 MM1 S1 a 2
1 MM1 S1 n **3**
2 MM1 S3 cb **5**
3 MM2 S3 mk **8**
4 MM2 S4 bg **5**
5 MM2 S4 dgd 1
6 MM4 S2 rd 2
7 MM4 S2 cb 2
8 MM4 S2 uyi **7**
```

Expected output: get the result rows whose count is max in each group, like:

```
1 MM1 S1 n **3**
2 MM1 S3 cb **5**
3 MM2 S3 mk **8**
4 MM2 S4 bg **5**
8 MM4 S2 uyi **7**
```
"""

retrieve_polars_knowledge(task)

# %% [markdown]
# Finally, register the retrieval tool with a chatlas chatbot. Copy the task
# from the previous block and paste it into the chatbot, or ask it your own
# questions about the Polars Cookbook.

# %%
chat = chatlas.ChatPosit(
    model="zai-org/GLM-5.3-Flash",
    system_prompt="""
You are an expert Python programmer and mentor. You are concise.

Before responding, retrieve relevant material from the knowledge store. Quote or
paraphrase passages, clearly marking your own words versus the source, and tell
the user which cookbook chapter each passage came from.
""",
)

chat.register_tool(retrieve_polars_knowledge)

chat.app()
