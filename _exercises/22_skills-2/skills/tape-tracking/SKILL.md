---
name: tape-tracking
description: Track unreturned tapes and prepare return reminders. Use when a tape is still out or a member may have one.
---

# Tape tracking

Check `rentals.csv` for rows where `returned` is empty.
Those tapes are still out.

For each tape still out, record:
the member, the title, the rental date, and how long it has been out.

Save the list as a new CSV in the workspace.
Do not edit `rentals.csv` — it is a register export.

A tape still out blocks a member from the win-back list.
Flag those members so the audit skips them.

Reminders go out by email, one short paragraph, friendly not stern.
Do not mention late fees. The manager handles accounts personally.
