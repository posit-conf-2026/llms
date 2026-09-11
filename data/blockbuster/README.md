# The Last Blockbuster

The Last Blockbuster is a video store in Bend, Oregon.
It is the last surviving Blockbuster store in the United States.

The store runs an annual membership renewal drive to keep the lights on.
The 2026 campaign date is September 1, 2026.
The drive identifies members who have gone quiet and gives the manager a list to review.

The store still uses a mix of paper-era records and CSV exports.
`members.csv` contains `member_id`, `name`, `email`, `tier`, `joined`, and `notes`.
`rentals.csv` is the current register export with `member_id`, `title`, `rented`, and `returned`.
`dues.csv` records `member_id` and `paid_on`.
Older rentals can arrive as another export.
Read `policies.md` before you decide which members belong on the win-back list.
