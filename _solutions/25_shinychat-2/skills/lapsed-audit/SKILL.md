---
name: lapsed-audit
description: Audit membership records to find lapsed members and maintain the win-back list. Use when identifying lapsed members or updating the list.
---

# Lapsed audit

A member is lapsed when they have no rental in the last 90 days
and no dues payment in the last 12 months.
A member with an unreturned tape is never lapsed — get the tape back first.

Work from `members.csv`, `rentals.csv`, and `dues.csv`.
Read `notes.md` before you decide anything; it carries the campaign date and exceptions.

Order the win-back list: Founders, then Family, then Basic.
Within a tier, most recent activity first.

Write the list to a new file.
Never delete rows from store records, and never edit the exports.
