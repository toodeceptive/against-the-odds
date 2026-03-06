# Finalize current branch for PR or handoff

1. **Inspect changes**: Run `git status` and `git diff` (staged and unstaged). Understand what changed.
2. **Commit message**: Write a clear commit message from the changes. Follow conventional style if the project uses it (e.g. `feat:`, `fix:`, `docs:`).
3. **Commit and push**: Commit staged changes (or stage and commit). Push to the current branch (`git push -u origin <branch>` if first push).
4. **Prepare PR summary**: Draft the concise PR title/summary, key verification results, and any residual risks so the branch is ready for a PR or automated handoff flow.
5. **Return**: Reply with the pushed branch, suggested PR title/summary, and one-line status.

Do not create or modify a PR unless the user explicitly asks for that step.
