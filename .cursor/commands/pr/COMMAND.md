# Create a pull request for current changes

1. **Inspect changes**: Run `git status` and `git diff` (staged and unstaged). Understand what changed.
2. **Commit message**: Write a clear commit message from the changes. Follow conventional style if the project uses it (e.g. `feat:`, `fix:`, `docs:`).
3. **Commit and push**: Commit staged changes (or stage and commit). Push to the current branch (`git push -u origin <branch>` if first push).
4. **Open PR**: Run `gh pr create` (or open in browser). Use a concise title and description summarizing the change. Reference any issue if applicable (e.g. "Fixes #123").
5. **Return**: Reply with the PR URL and one-line summary.

If `gh` is not installed or auth fails, tell the user to run `gh auth login` or create the PR manually from the pushed branch.
