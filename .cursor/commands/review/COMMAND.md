# Review current changes

Run a quick quality pass on the current state of the repo and report what needs attention.

1. **Lint**: Run the project linter (e.g. `npm run lint` or `npx eslint .`) on changed or relevant paths. Summarize errors and warnings.
2. **Format**: If the project uses Prettier, run it (e.g. `npm run format` or `npx prettier -c .`). Note any files that would change.
3. **Tests**: Run the test suite (e.g. `npm run test` or `npm test`). Prefer focused runs if only some files changed. Report pass/fail and any failures.
4. **Summary**: Return a short report:
   - **Lint**: [pass / N errors, M warnings]
   - **Format**: [clean / N files would change]
   - **Tests**: [pass / N failed]
   - **Recommendations**: [what to fix first, or "ready for commit"]

Do not make edits unless the user asks you to fix issues. This command is for assessment only.
