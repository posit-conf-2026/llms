script_path <- sub(
  "^--file=",
  "",
  commandArgs(trailingOnly = FALSE)[grep(
    "^--file=",
    commandArgs(trailingOnly = FALSE)
  )]
)
root <- dirname(dirname(dirname(normalizePath(script_path))))
source_dir <- file.path(root, "data", "blockbuster")
campaign_date <- as.Date("2026-09-01")

members <- read.csv(
  file.path(source_dir, "members.csv"),
  na.strings = "",
  stringsAsFactors = FALSE,
  check.names = FALSE
)
dues <- read.csv(
  file.path(source_dir, "dues.csv"),
  stringsAsFactors = FALSE,
  check.names = FALSE
)
members <- members[!duplicated(members$member_id), ]

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

edge_rentals <- data.frame(
  member_id = c(
    "M001",
    "M002",
    "M003",
    "M004",
    "M005",
    "M006",
    "M007",
    "M008",
    "M009",
    "M010",
    "M011",
    "M012",
    "M013",
    "M014"
  ),
  title = c(
    "The Goonies",
    "The Matrix",
    "A League of Their Own",
    "Fargo",
    "Toy Story",
    "Die Hard",
    "The Princess Bride",
    "The Truman Show",
    "Ghostbusters",
    "Clueless",
    "The Iron Giant",
    "Moonrise Kingdom",
    "Little Miss Sunshine",
    "Point Break"
  ),
  rented = c(
    "2026-03-20",
    "2026-04-10",
    "2026-05-01",
    "2026-04-30",
    "2026-05-20",
    "2026-03-13",
    "2026-05-10",
    "2026-05-31",
    "2026-04-15",
    "2026-03-20",
    "2026-05-10",
    "2026-06-06",
    "2025-09-01",
    "2026-04-15"
  ),
  returned = c(
    "2026-03-23",
    "2026-04-13",
    "2026-05-04",
    "2026-05-03",
    "2026-05-23",
    "2026-03-16",
    "2026-05-13",
    "2026-06-03",
    "2026-04-18",
    "2026-03-23",
    "2026-05-13",
    "2026-06-09",
    "2025-09-04",
    ""
  ),
  stringsAsFactors = FALSE
)

safe_member_ids <- sprintf("M%03d", 15:39)
set.seed(20260901)
forced_recent <- data.frame(
  member_id = safe_member_ids,
  title = sample(movie_titles, length(safe_member_ids), replace = TRUE),
  rented = as.character(
    as.Date("2026-08-01") +
      sample(0:30, length(safe_member_ids), replace = TRUE)
  ),
  returned = NA_character_,
  stringsAsFactors = FALSE
)
forced_recent$returned <- as.character(
  as.Date(forced_recent$rented) +
    sample(1:4, nrow(forced_recent), replace = TRUE)
)

bulk_rows <- 1500L - nrow(edge_rentals) - nrow(forced_recent)
bulk <- data.frame(
  member_id = sample(safe_member_ids, bulk_rows, replace = TRUE),
  title = sample(movie_titles, bulk_rows, replace = TRUE),
  rented = as.character(
    as.Date("2025-03-01") + sample(0:548, bulk_rows, replace = TRUE)
  ),
  returned = NA_character_,
  stringsAsFactors = FALSE
)
bulk$returned <- as.character(
  as.Date(bulk$rented) + sample(1:7, nrow(bulk), replace = TRUE)
)
rentals <- rbind(edge_rentals, forced_recent, bulk)
rentals <- rentals[order(as.Date(rentals$rented), rentals$member_id), ]
row.names(rentals) <- NULL

old_recent <- data.frame(
  member_id = c("M009", "M010", "M011"),
  title = c("The Last Unicorn", "The Muppet Movie", "The NeverEnding Story"),
  rented = c("2026-08-15", "2026-07-31", "2026-08-02"),
  returned = c("2026-08-18", "2026-08-03", "2026-08-05"),
  stringsAsFactors = FALSE
)
old_bulk_rows <- 80L - nrow(old_recent)
old_bulk <- data.frame(
  member_id = sample(members$member_id, old_bulk_rows, replace = TRUE),
  title = sample(movie_titles, old_bulk_rows, replace = TRUE),
  rented = as.character(
    as.Date("2024-01-01") + sample(0:364, old_bulk_rows, replace = TRUE)
  ),
  returned = NA_character_,
  stringsAsFactors = FALSE
)
old_bulk$returned <- as.character(
  as.Date(old_bulk$rented) + sample(1:7, nrow(old_bulk), replace = TRUE)
)
rentals_old <- rbind(old_recent, old_bulk)
rentals_old <- rentals_old[
  order(as.Date(rentals_old$rented), rentals_old$member_id),
]
row.names(rentals_old) <- NULL

latest_date <- function(values) {
  values <- as.Date(values)
  values <- values[!is.na(values)]

  if (length(values) == 0L) {
    as.Date(NA)
  } else {
    max(values)
  }
}

last_title <- function(member_id, rentals) {
  member_rentals <- rentals[rentals$member_id == member_id, ]

  if (nrow(member_rentals) == 0L) {
    NA_character_
  } else {
    member_rentals$title[which.max(as.Date(member_rentals$rented))]
  }
}

most_recent_activity <- function(rental_date, due_date) {
  dates <- c(rental_date, due_date)
  dates <- dates[!is.na(dates)]

  if (length(dates) == 0L) {
    as.Date(NA)
  } else {
    max(dates)
  }
}

find_lapsed <- function(rentals, rentals_old = NULL) {
  all_rentals <- rbind(rentals, rentals_old)
  last_rented <- vapply(
    members$member_id,
    function(member_id) {
      latest_date(all_rentals$rented[all_rentals$member_id == member_id])
    },
    as.Date(NA)
  )
  last_paid <- vapply(
    members$member_id,
    function(member_id) latest_date(dues$paid_on[dues$member_id == member_id]),
    as.Date(NA)
  )
  has_open_rental <- vapply(
    members$member_id,
    function(member_id) {
      returns <- all_rentals$returned[all_rentals$member_id == member_id]
      any(is.na(returns) | returns == "")
    },
    logical(1)
  )
  recent_rental <- !is.na(last_rented) & campaign_date - last_rented <= 90
  recent_dues <- !is.na(last_paid) & campaign_date - last_paid <= 365
  lapsed <- !recent_rental & !recent_dues & !has_open_rental
  activity <- mapply(most_recent_activity, last_rented, last_paid)
  tiers <- match(members$tier, c("Founders", "Family", "Basic"))

  win_back <- data.frame(
    name = members$name[lapsed],
    email = members$email[lapsed],
    tier = members$tier[lapsed],
    days_quiet = as.integer(campaign_date - last_rented[lapsed]),
    last_title = vapply(
      members$member_id[lapsed],
      last_title,
      character(1),
      rentals = all_rentals
    ),
    activity = as.Date(activity[lapsed], origin = "1970-01-01"),
    tier_order = tiers[lapsed],
    stringsAsFactors = FALSE
  )
  win_back <- win_back[
    order(win_back$tier_order, -as.numeric(win_back$activity), win_back$name),
  ]
  win_back[, c("name", "email", "tier", "days_quiet", "last_title")]
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

write_csv <- function(data, path) {
  write.csv(data, path, row.names = FALSE, na = "")
}

write_workspace <- function(
  path,
  include_old = FALSE,
  include_lapsed = FALSE,
  include_drafts = FALSE
) {
  workspace <- file.path(path, "blockbuster")
  unlink(workspace, recursive = TRUE)
  dir.create(workspace, recursive = TRUE)

  file.copy(
    file.path(
      source_dir,
      c("README.md", "policies.md", "members.csv", "dues.csv")
    ),
    workspace
  )
  write_csv(rentals, file.path(workspace, "rentals.csv"))

  if (include_old) {
    write_csv(rentals_old, file.path(workspace, "rentals-old.csv"))
  }

  if (include_lapsed) {
    write_csv(lapsed_with_old, file.path(workspace, "lapsed.csv"))
  }

  if (include_drafts) {
    drafts <- file.path(workspace, "letters", "drafts")
    dir.create(drafts, recursive = TRUE)
    file.create(file.path(drafts, ".gitkeep"))
  }
}

for (folder in c("_exercises/22_agent-1", "_solutions/22_agent-1")) {
  write_workspace(file.path(root, folder))
}

for (folder in c("_exercises/23_agent-2", "_solutions/23_agent-2")) {
  write_workspace(file.path(root, folder), include_old = TRUE)
}

for (folder in c(
  "_exercises/24_skills-1",
  "_solutions/24_skills-1",
  "_exercises/25_skills-2",
  "_solutions/25_skills-2"
)) {
  write_workspace(
    file.path(root, folder),
    include_old = TRUE,
    include_lapsed = TRUE,
    include_drafts = TRUE
  )
}

expected_files <- list(
  `22_agent-1` = c(
    "README.md",
    "dues.csv",
    "members.csv",
    "policies.md",
    "rentals.csv"
  ),
  `23_agent-2` = c(
    "README.md",
    "dues.csv",
    "members.csv",
    "policies.md",
    "rentals-old.csv",
    "rentals.csv"
  ),
  `24_skills-1` = c(
    "README.md",
    "dues.csv",
    "lapsed.csv",
    "letters/drafts/.gitkeep",
    "members.csv",
    "policies.md",
    "rentals-old.csv",
    "rentals.csv"
  ),
  `25_skills-2` = c(
    "README.md",
    "dues.csv",
    "lapsed.csv",
    "letters/drafts/.gitkeep",
    "members.csv",
    "policies.md",
    "rentals-old.csv",
    "rentals.csv"
  )
)

for (exercise in names(expected_files)) {
  for (parent in c("_exercises", "_solutions")) {
    workspace <- file.path(root, parent, exercise, "blockbuster")
    actual_files <- sort(list.files(
      workspace,
      all.files = TRUE,
      recursive = TRUE,
      include.dirs = FALSE
    ))
    stopifnot(identical(actual_files, sort(expected_files[[exercise]])))
  }
}

cat(
  "Wrote ",
  nrow(rentals),
  " current rentals, ",
  nrow(rentals_old),
  " old rentals, ",
  nrow(lapsed_current),
  " lapsed members for Exercise 22, and ",
  nrow(lapsed_with_old),
  " lapsed members for Exercises 23 through 25.\n",
  sep = ""
)
