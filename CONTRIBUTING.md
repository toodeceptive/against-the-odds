# Contributing to Against the Odds

Thank you for your interest in contributing to the AO project!  We welcome contributions of all kinds: new features, bug fixes, documentation improvements and suggestions.  To make the process smooth for everyone, please follow these guidelines.

## Code of Conduct

This project adheres to a [code of conduct](CODE_OF_CONDUCT.md); by participating you agree to uphold these standards.  Please report unacceptable behaviour to the maintainers.

## Getting Started

1. **Fork the repository** and clone your fork locally.
2. **Install dependencies** using `npm ci` (or `pnpm install` if you prefer another package manager).
3. Copy `.env.example` to `.env.local` and configure any required environment variables.
4. Use `npm run test:all` to run unit, integration and end‑to‑end tests.
5. Use `npm run quality` to run formatting, linting and unit tests.

## Branching & Commits

* Create descriptive branch names prefixed with the type of change, e.g. `feature/checkout-form` or `bugfix/fix-lighthouse-error`.
* Write clear, concise commit messages following the conventional commits style (e.g. `fix(ci): add caching to workflow`).
* Squash commits before opening a pull request if there are many small fixes.

## Pull Requests

* Make sure your branch is up to date with `main` before opening a PR.
* Provide a description of **what** and **why** in the PR body.  Reference any related issues.
* Ensure that CI checks pass.  The workflow will run tests, linters and secret scans.
* Include screenshots or videos when modifying UI or visual elements.
* Request a review from one of the maintainers.  Reviews may suggest changes or improvements.

## Pre‑Commit Hooks

We recommend using [Husky](https://typicode.github.io/husky/#/) and [lint‑staged](https://github.com/okonet/lint-staged) to run linters and formatters automatically before each commit.  This repository includes an optional setup script:

```sh
npm install --save-dev husky lint-staged
npx husky install
```

Then configure `.husky/pre-commit` to run `npm run quality`.

## Reporting Issues

If you encounter a bug or have a feature request, please [open an issue](https://github.com/toodeceptive/against-the-odds/issues) with steps to reproduce or a clear description of your idea.  Use labels to categorise the issue (bug, feature, documentation, performance, etc.).

## Thank You

Your contributions help make the AO project better for everyone.  We appreciate your time and effort!
