# Guru Expert Audit and Fix — Self-Execute Prompt

**Purpose**: Execute a flawlessly scoped audit, apply fixes with guru expert skills, and document outcomes. User approval pre-granted for fixes and commits.

## Directives (Prodigy Protocol)

1. **State intent**: Full system audit (CI, workflows, Codacy, quality gates) → identify issues → fix → verify → document → commit.
2. **Parse constraints**: No store-affecting changes without preview+approval; no secrets in commits; respect AGENTS.md and .cursor/rules.
3. **Success criteria**: Quality passes; verify-pipeline passes; no linter errors; all fixes committed and pushed.

## Execution Phases

### Phase 1: Audit

- [ ] Run `npm run quality` (format, lint, test:unit)
- [ ] Run `scripts/verify-pipeline.ps1 -SkipRunbook`
- [ ] Read workflows: ci.yml, maintenance.yml, codeql.yml, shopify-sync.yml, sync-theme-branch.yml
- [ ] Read .codacy.yml, .prettierignore, package.json (scripts, lint-staged)
- [ ] Check ReadLints on .github/workflows, .codacy
- [ ] Identify: Codacy Semgrep (action SHA pinning), Prettier drift, ESLint, missing pins, doc gaps

### Phase 2: Fix

- [ ] Pin third-party actions to full 40-char commit SHAs (Trivy, create-pull-request, Lighthouse, etc.)
- [ ] Fix .codacy/codacy.yaml Prettier if needed (include in format scope, lint-staged)
- [ ] Add .codacy.yml exclude_paths if Codacy Cloud conflicts
- [ ] Align workflow resilience (continue-on-error where appropriate)
- [ ] Update CHANGELOG with fixes

### Phase 3: Verify and Document

- [ ] Re-run `npm run quality`
- [ ] Re-run verify-pipeline
- [ ] Append CONSOLIDATION_LOG.md with audit summary
- [ ] Commit with conventional message; push to main

## Recovery

- On any failure: capture error, form hypothesis, apply smallest fix, re-verify.
- Avoid loops: track what changed between attempts.

## Continuous Audit (post-step)

- **Aligned?** Did this advance the goal?
- **Efficient?** Simpler/safer approach?
- **Improvable?** What reduces future risk?
- **Obsolete?** Anything redundant?
