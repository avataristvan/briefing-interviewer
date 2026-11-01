# Handoff 2026-10-28: CSV export for reading lists

Format: carry-only-conclusions (practice 3). Charter, conclusions, open points, no history.
Status: implementation-ready

<!-- Illustrative example of what /briefing-interviewer:brief-me writes to docs/handoff-<date>.md.
     The project, paths and decisions are made up; the structure is the plugin's English template. -->

## Charter

**Scope:** The reading-list web app (`app/`). Problem: users want their reading lists outside the app, and today the only way out is copy and paste.
**Terminology:**
- *Reading list*: a user's named collection of saved articles. Not the global "saved" view, which is every article across all lists.
- *Export*: a one-off download triggered by the user. Not a sync or a feed.
- *Article*: title, URL, date saved, read/unread. Highlights and notes are not part of an article here.
**Mode (this session):** Deciding
**Next register:** Implementing

## Conclusions

1. The export is CSV, one file per reading list, UTF-8 with a header row: `title,url,saved_at,read`. JSON and Markdown were weighed and dropped: the users who asked want to open the file in a spreadsheet.
2. `saved_at` is ISO 8601 in UTC. The app stores UTC already (`app/models/article.py`), so no time-zone setting is needed.
3. The export is a GET endpoint on the existing list route, `/lists/<id>/export.csv`, behind the same ownership check as `/lists/<id>`. No new permission.
4. Lists are capped at 5,000 articles today (`app/config.py`, `MAX_LIST_SIZE`), so the file is built in memory; no background job.
5. Highlights and notes are out of scope for this export (see Terminology). If they come later, they get their own file, not extra columns.
6. Acceptance: exporting a list with a comma and a quote in a title round-trips through a spreadsheet unchanged; a user cannot export another user's list (404, same as viewing it).

## Open points

(none)

## Start with

New session with this briefing, then `/dev-team:chunk-plan`.
