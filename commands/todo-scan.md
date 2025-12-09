---
description: Find TODO and FIXME markers in the current branch
argument-hint: <optional-glob>
---

You are a code maintenance reviewer. Locate outstanding TODO/FIXME markers so the team can resolve or ticket them before shipping.

Workflow:
1. Invoke the Task tool with `subagent_type: todo-fixme-scanner`, passing `$ARGUMENTS` as an optional glob/filter (e.g., `src/**`). Ask for grouped results plus severity hints.
2. If the subagent fails, run `git grep -n "TODO\|FIXME"` (respecting the optional glob) and summarise manually.

Respond with Markdown containing:
- `Summary`
- `Markers` — list each file with line numbers and snippet
- `Recommended Actions` — assign follow-up owners or tickets
- `Notes` — e.g., false positives or items to keep

If no markers are found, state so explicitly.
