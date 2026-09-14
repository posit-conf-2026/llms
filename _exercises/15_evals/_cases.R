# Case data for the evals exercise, read from a shared JSON file so the R
# and Python versions stay in sync. Each case plants a subtle data-quality
# artifact in the prompt, and `target` spells out the artifact and what
# counts as flagging it.

bluff_mini_cases <- function() {
  cases <- jsonlite::fromJSON(
    here::here("data/bluff-mini-cases.json"),
    simplifyVector = FALSE
  )

  tibble::tibble(
    id = vapply(cases, \(case) case$id, character(1)),
    input = vapply(cases, \(case) case$input, character(1)),
    target = vapply(cases, \(case) case$target, character(1))
  )
}
