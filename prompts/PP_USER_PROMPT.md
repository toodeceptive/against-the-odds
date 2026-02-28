# PP User Prompt — Perfected

**Purpose**: The one prompt you use with `/pp` when talking to Cursor agents. Optimal for any PP execution.

**Use**: `/pp` + paste the prompt below, or `/pp` + prompt + your specific task.

---

## The prompt (copy this)

```
Run PP: parse intent → task tree (2–6 steps) → execute smallest step → validate → audit → report. If no task given: run full project cycle (prompts/PP_EXECUTE_PROJECT_PROMPT.md). If intent unclear: ask once. No redundancy (read CONSOLIDATION_LOG first). No store changes without preview+approval. No secrets in commits.
```

---

## One-liner (for chat)

```
/pp Run PP on my request; if empty run full project cycle. No redundancy, no store changes without approval.
```

---

## Invocation guide

| You say                                      | Agent does                                            |
| -------------------------------------------- | ----------------------------------------------------- |
| `/pp`                                        | Asks for intent or runs full project cycle per prompt |
| `/pp [prompt above]`                         | Runs PP with default behavior (full cycle if no task) |
| `/pp [prompt] fix the broken link in README` | Runs PP on that specific task                         |
| `/pp execute pp_execute_project_prompt`      | Runs full project PP cycle                            |
