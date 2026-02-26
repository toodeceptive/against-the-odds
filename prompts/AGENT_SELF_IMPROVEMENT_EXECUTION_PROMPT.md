# Agent Self-Improvement: Performance, Task Management & Tool Leverage

**Purpose**: Execute this prompt to identify, fix, and resolve agent performance degradation; improve work/task management; optimize application & extension usage; and maximize tool leverage. Run after observing declined performance or when tuning for excellence.

---

## Directive

Execute a **deep-research self-audit** and apply fixes to restore and exceed prior performance. Identify root causes of performance decline, work/task management gaps, underused tools, and application/extension misconfigurations. Implement corrections and document findings.

---

## Phase 1: Identify & Diagnose

1. **Problem inventory**
   - List all Problems panel issues (ESLint, Codacy, TypeScript/JSDoc, markdownlint, Lizard).
   - For each: file, line, rule, severity. Group by type (type errors, lint, complexity, style).

2. **Root-cause analysis**
   - **Type/JSDoc**: Missing `@typedef`, wrong return types, undefined globals in evaluate callbacks.
   - **Lint**: Config mismatch (project vs Codacy), missing globals for mixed Node/browser context.
   - **Complexity**: Functions over cyclomatic 8 or NLOC 50; extract helpers.
   - **Style**: MD031, Prettier drift; fix blanks, formatting.

3. **Tool usage audit**
   - Did the agent use: ReadLints, grep, semantic search, verify-pipeline, Codacy MCP?
   - Were edits verified with `npm run quality` before commit?
   - Were multiple problems batched and fixed in logical groups?

4. **Task management audit**
   - Were todos used for multi-step work?
   - Was work verified after each phase before proceeding?
   - Were remaining issues explicitly tracked?

---

## Phase 2: Fix All Issues

1. **JSDoc & types**
   - Add `@typedef` for Playwright types: `Browser`, `Page`.
   - Fix return types: `Promise<string|null>` where null is possible.
   - Fix evaluate callbacks: use `instanceof HTMLInputElement` for `el.value` to satisfy TS.

2. **ESLint/Codacy globals**
   - Ensure `eslint.config.mjs` has `src/browser-automation` override with globals (URL, fetch, process, document, window).
   - If Codacy uses separate config, add globals to `.codacy/tools-configs/eslint.config.mjs` or document as known gap.

3. **Complexity (Lizard)**
   - Extract helpers: `clickFirstAppDetailLink`, `clickRevealButtons`, `openDevDashboardPopup`, `tryOAuthEndpoint`, `extractTokenFrom*`.
   - Target: cyclomatic < 8, NLOC < 50 per function.

4. **Markdown**
   - MD031: Add blank lines before/after fenced code blocks.

---

## Phase 3: Optimize Execution

1. **Pre-edit checklist**
   - Run `ReadLints` on target file before editing.
   - Run `npm run quality` after edits; fix any regressions.

2. **Batch fixes**
   - Fix related issues together (e.g. all JSDoc in one pass, all complexity in one refactor).
   - Avoid partial fixes that leave inconsistent state.

3. **Verification loop**
   - After fixes: `npm run quality` → `verify-pipeline.ps1 -SkipRunbook` → commit only when green.

4. **Codacy**
   - Run `codacy_cli_analyze` on edited files per `.cursor/rules/codacy.mdc`.

---

## Phase 4: Document & Prevent

1. **Update prompts**
   - Add fix patterns to `PROCEED_UNFINISHED_WORKS_GURU_PROMPT.md`.
   - Ensure "Fix all problems" includes: ReadLints, type/JSDoc, complexity, style.

2. **Update skills**
   - In `agentic-performance` SKILL: emphasize "Run ReadLints before and after edits; fix all Problems before commit."

3. **Checklist for future runs**
   - [ ] ReadLints on affected files first
   - [ ] Fix type/JSDoc issues (typedef, return types, instanceof)
   - [ ] Fix complexity (extract helpers)
   - [ ] Fix style (MD031, Prettier)
   - [ ] Run quality gate before commit
   - [ ] Run Codacy on edited files

---

## Success Criteria

- Problems panel: 0 errors.
- `npm run quality` passes.
- `verify-pipeline.ps1 -SkipRunbook` passes.
- All edits committed with clear messages.
- This prompt and checklists updated for future runs.

---

_Execute this prompt when performance declines or to tune for excellence. Iterate until all criteria are met._
