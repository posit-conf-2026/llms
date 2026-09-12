# Generates the blockbuster/ workspaces for Exercises 22-25.
# Seeded, so re-running reproduces the CSVs exactly: Rscript data/blockbuster/_generate.R

library(dplyr, warn.conflicts = FALSE)
library(readr)
library(fs)
library(purrr)
library(cli)

args <- commandArgs(trailingOnly = FALSE)
script_path <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
source_dir <- path_dir(path_real(script_path))
root <- path_dir(path_dir(source_dir))

campaign_date <- as.Date("2026-09-01")

set.seed(20260901)

members <- read_csv(
  path(source_dir, "members.csv"),
  na = "",
  show_col_types = FALSE
) |>
  distinct(member_id, .keep_all = TRUE)

dues <- read_csv(path(source_dir, "dues.csv"), show_col_types = FALSE)

movie_titles <- c(
  "The Goonies",
  "Back to the Future",
  "The Princess Bride",
  "E.T. the Extra-Terrestrial",
  "The Breakfast Club",
  "Ghostbusters",
  "Ferris Bueller's Day Off",
  "The Lost Boys",
  "Beetlejuice",
  "Die Hard",
  "When Harry Met Sally...",
  "Do the Right Thing",
  "The Little Mermaid",
  "Goodfellas",
  "Point Break",
  "Terminator 2: Judgment Day",
  "The Silence of the Lambs",
  "A League of Their Own",
  "Clueless",
  "Toy Story",
  "Fargo",
  "The Big Lebowski",
  "The Truman Show",
  "The Matrix",
  "The Iron Giant",
  "Bring It On",
  "Spirited Away",
  "Ocean's Eleven",
  "Bend It Like Beckham",
  "Mean Girls",
  "Eternal Sunshine of the Spotless Mind",
  "Napoleon Dynamite",
  "Little Miss Sunshine",
  "No Country for Old Men",
  "The Dark Knight",
  "Coraline",
  "Moonrise Kingdom"
)

# Hand-written rows for the edge-case members: each of M001-M014 exercises a
# different branch of the lapsed-member logic (open rental, boundary dates, ...).
edge_rentals <- tribble(
  ~member_id , ~title                  , ~rented      , ~returned    ,
  "M001"     , "The Goonies"           , "2026-03-20" , "2026-03-23" ,
  "M002"     , "The Matrix"            , "2026-04-10" , "2026-04-13" ,
  "M003"     , "A League of Their Own" , "2026-05-01" , "2026-05-04" ,
  "M004"     , "Fargo"                 , "2026-04-30" , "2026-05-03" ,
  "M005"     , "Toy Story"             , "2026-05-20" , "2026-05-23" ,
  "M006"     , "Die Hard"              , "2026-03-13" , "2026-03-16" ,
  "M007"     , "The Princess Bride"    , "2026-05-10" , "2026-05-13" ,
  "M008"     , "The Truman Show"       , "2026-05-31" , "2026-06-03" ,
  "M009"     , "Ghostbusters"          , "2026-04-15" , "2026-04-18" ,
  "M010"     , "Clueless"              , "2026-03-20" , "2026-03-23" ,
  "M011"     , "The Iron Giant"        , "2026-05-10" , "2026-05-13" ,
  "M012"     , "Moonrise Kingdom"      , "2026-06-06" , "2026-06-09" ,
  "M013"     , "Little Miss Sunshine"  , "2025-09-01" , "2025-09-04" ,
  "M014"     , "Point Break"           , "2026-04-15" , NA
) |>
  mutate(across(c(rented, returned), as.Date))

# Members M015-M039 are "safe": the generated history guarantees each of them a
# rental within 90 days of the campaign, so they can never appear as lapsed.
safe_member_ids <- sprintf("M%03d", 15:39)

forced_recent <- tibble(
  member_id = safe_member_ids,
  title = sample(movie_titles, length(safe_member_ids), replace = TRUE),
  rented = as.Date("2026-08-01") +
    sample(0:30, length(safe_member_ids), replace = TRUE)
) |>
  mutate(returned = rented + sample(1:4, n(), replace = TRUE))

n_bulk <- 1500L - nrow(edge_rentals) - nrow(forced_recent)

bulk <- tibble(
  member_id = sample(safe_member_ids, n_bulk, replace = TRUE),
  title = sample(movie_titles, n_bulk, replace = TRUE),
  rented = as.Date("2025-03-01") + sample(0:548, n_bulk, replace = TRUE)
) |>
  mutate(returned = rented + sample(1:7, n(), replace = TRUE))

rentals <- bind_rows(edge_rentals, forced_recent, bulk) |>
  arrange(rented, member_id)

# The "old" export deliberately hides three recent rentals (M009-M011): folding
# it into the history changes the lapsed answer, which is the point of Ex. 23-25.
old_recent <- tribble(
  ~member_id , ~title                  , ~rented      , ~returned    ,
  "M009"     , "The Last Unicorn"      , "2026-08-15" , "2026-08-18" ,
  "M010"     , "The Muppet Movie"      , "2026-07-31" , "2026-08-03" ,
  "M011"     , "The NeverEnding Story" , "2026-08-02" , "2026-08-05"
) |>
  mutate(across(c(rented, returned), as.Date))

n_old_bulk <- 80L - nrow(old_recent)

old_bulk <- tibble(
  member_id = sample(members$member_id, n_old_bulk, replace = TRUE),
  title = sample(movie_titles, n_old_bulk, replace = TRUE),
  rented = as.Date("2024-01-01") + sample(0:364, n_old_bulk, replace = TRUE)
) |>
  mutate(returned = rented + sample(1:7, n(), replace = TRUE))

rentals_old <- bind_rows(old_recent, old_bulk) |>
  arrange(rented, member_id)

latest_date <- function(dates) {
  dates <- dates[!is.na(dates)]
  if (length(dates) == 0) as.Date(NA) else max(dates)
}

find_lapsed <- function(rentals, rentals_old = NULL) {
  all_rentals <- bind_rows(rentals, rentals_old)

  rental_history <- all_rentals |>
    group_by(member_id) |>
    summarise(
      last_rented = latest_date(rented),
      last_title = title[which.max(rented)],
      has_open_rental = any(is.na(returned)),
      .groups = "drop"
    )

  dues_history <- dues |>
    group_by(member_id) |>
    summarise(last_paid = latest_date(paid_on), .groups = "drop")

  members |>
    left_join(rental_history, by = "member_id") |>
    left_join(dues_history, by = "member_id") |>
    mutate(
      recent_rental = !is.na(last_rented) & campaign_date - last_rented <= 90,
      recent_dues = !is.na(last_paid) & campaign_date - last_paid <= 365,
      has_open_rental = coalesce(has_open_rental, FALSE)
    ) |>
    filter(!recent_rental & !recent_dues & !has_open_rental) |>
    mutate(
      days_quiet = as.integer(campaign_date - last_rented),
      activity = map2_vec(
        last_rented,
        last_paid,
        \(rented, paid) latest_date(c(rented, paid)),
        .ptype = as.Date(NA)
      ),
      tier_order = match(tier, c("Founders", "Family", "Basic"))
    ) |>
    arrange(tier_order, desc(activity), name) |>
    select(name, email, tier, days_quiet, last_title)
}

lapsed_current <- find_lapsed(rentals)
lapsed_with_old <- find_lapsed(rentals, rentals_old)

stopifnot(
  nrow(rentals) == 1500L,
  nrow(rentals_old) == 80L,
  nrow(lapsed_current) == 11L,
  nrow(lapsed_with_old) == 8L,
  identical(
    sort(setdiff(lapsed_current$name, lapsed_with_old$name)),
    sort(c("Greta Moss", "Nora Ellis", "Peter Ibarra"))
  ),
  identical(
    sort(lapsed_with_old$name),
    sort(c(
      "Anita Flores",
      "Calvin Brooks",
      "Elaine Wu",
      "June Park",
      "Malik Johnson",
      "Marisol Vega",
      "Robert Singh",
      "Theo Bennett"
    ))
  )
)

write_workspace <- function(
  dir,
  include_old = FALSE,
  include_lapsed = FALSE,
  include_drafts = FALSE
) {
  workspace <- path(dir, "blockbuster")
  if (dir_exists(workspace)) {
    dir_delete(workspace)
  }
  cli::cli_progress_step("Prepping workspace for {.path {fs::path_rel(dir)}}")
  dir_create(workspace)

  file_copy(
    path(source_dir, c("README.md", "notes.md", "members.csv", "dues.csv")),
    workspace
  )
  write_csv(rentals, path(workspace, "rentals.csv"), na = "")

  if (include_old) {
    write_csv(rentals_old, path(workspace, "rentals-old.csv"), na = "")
  }
  if (include_lapsed) {
    write_csv(lapsed_with_old, path(workspace, "lapsed.csv"), na = "")
  }
  if (include_drafts) {
    dir_create(path(workspace, "letters", "drafts"))
    file_create(path(workspace, "letters", "drafts", ".gitkeep"))
  }
}

workspace_specs <- tribble(
  ~exercise     , ~include_old , ~include_lapsed , ~include_drafts ,
  "19_agent-1"  , FALSE        , FALSE           , FALSE           ,
  "20_agent-2"  , TRUE         , FALSE           , FALSE           ,
  "21_skills-1" , TRUE         , TRUE            , TRUE            ,
  "22_skills-2" , TRUE         , TRUE            , TRUE
)

write_exercise_workspaces <- function(
  exercise,
  include_old,
  include_lapsed,
  include_drafts
) {
  for (parent in c("_exercises", "_solutions")) {
    write_workspace(
      path(root, parent, exercise),
      include_old = include_old,
      include_lapsed = include_lapsed,
      include_drafts = include_drafts
    )
  }
}

pwalk(workspace_specs, write_exercise_workspaces)

# Skills are fixtures too: exercises get the bad first draft, solutions the
# fixed skill, and 22_skills-2 gets three rivals its description must compete
# with.
skills_source <- path(source_dir, "skills")

skill_sets <- tribble(
  ~exercise     , ~exercise_skill       , ~solution_skill   , ~rivals ,
  "21_skills-1" , "renewal-letters"     , "renewal-letters" , FALSE   ,
  "22_skills-2" , "renewal-letters-bad" , "renewal-letters" , TRUE
)

sync_skills <- function(exercise, exercise_skill, solution_skill, rivals) {
  cli::cli_progress_step("Syncing skills for {.path {exercise}}")
  for (parent in c("_exercises", "_solutions")) {
    skills_dir <- path(root, parent, exercise, "skills")
    if (dir_exists(skills_dir)) {
      dir_delete(skills_dir)
    }
    skill <- if (parent == "_exercises") exercise_skill else solution_skill
    dir_create(path(skills_dir, "renewal-letters"))
    file_copy(
      path(skills_source, skill, "SKILL.md"),
      path(skills_dir, "renewal-letters", "SKILL.md")
    )
    if (rivals) {
      for (rival in dir_ls(path(skills_source, "rivals"))) {
        dir_copy(rival, path(skills_dir, path_file(rival)))
      }
    }
  }
}

pwalk(skill_sets, sync_skills)

expected_files <- list(
  "19_agent-1" = c(
    "README.md",
    "dues.csv",
    "members.csv",
    "notes.md",
    "rentals.csv"
  ),
  "20_agent-2" = c(
    "README.md",
    "dues.csv",
    "members.csv",
    "notes.md",
    "rentals-old.csv",
    "rentals.csv"
  ),
  "21_skills-1" = c(
    "README.md",
    "dues.csv",
    "lapsed.csv",
    "letters/drafts/.gitkeep",
    "members.csv",
    "notes.md",
    "rentals-old.csv",
    "rentals.csv"
  ),
  "22_skills-2" = c(
    "README.md",
    "dues.csv",
    "lapsed.csv",
    "letters/drafts/.gitkeep",
    "members.csv",
    "notes.md",
    "rentals-old.csv",
    "rentals.csv"
  )
)

list_workspace_files <- function(dir) {
  dir_ls(dir, all = TRUE, recurse = TRUE, type = "file") |>
    path_rel(dir) |>
    as.character() |>
    sort()
}

verify_exercise_files <- function(expected, exercise) {
  for (parent in c("_exercises", "_solutions")) {
    workspace <- path(root, parent, exercise, "blockbuster")
    stopifnot(identical(list_workspace_files(workspace), sort(expected)))
  }
}

iwalk(expected_files, verify_exercise_files)

expected_skills <- list(
  "21_skills-1" = "renewal-letters/SKILL.md",
  "22_skills-2" = c(
    "lapsed-audit/SKILL.md",
    "renewal-letters/SKILL.md",
    "social-media-voice/SKILL.md",
    "tape-tracking/SKILL.md"
  )
)

verify_exercise_skills <- function(expected, exercise) {
  for (parent in c("_exercises", "_solutions")) {
    skills_dir <- path(root, parent, exercise, "skills")
    stopifnot(identical(list_workspace_files(skills_dir), sort(expected)))
  }
}

iwalk(expected_skills, verify_exercise_skills)

cli_alert_success(
  "Wrote {nrow(rentals)} current rentals, {nrow(rentals_old)} old rentals, \\
  {nrow(lapsed_current)} lapsed members for Exercise 22, and \\
  {nrow(lapsed_with_old)} lapsed members for Exercises 23 through 25."
)
