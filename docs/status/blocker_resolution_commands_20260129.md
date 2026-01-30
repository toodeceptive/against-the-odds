# Blocker Resolution — Exact Commands (Do Not Run Until Approved)

**Generated**: 2026-01-29  
**Purpose**: Step-by-step commands to resolve GitHub push protection and Windows-invalid filenames. Execute only after explicit approval.

**Resolution (2026-01-29)**: Push was **resolved** via history rewrite: `git-filter-repo` was run in the primary repo to remove the Shopify App Shared Secret from all commits; credentials were rotated; `main` was force-pushed to `origin`. The unblock URL below is kept for reference if future pushes trigger secret detection.

---

## Approval request (to complete push from Cursor)

To finish pushing this repo to GitHub from Cursor, two approvals are needed:

1. **Force-push**: Our local `main` will **replace** GitHub’s `main`. The 7 commits currently on GitHub (initial setup, logo PNGs) will be **removed** from the remote. Reply **"Approved"** or **"Yes"** to allow:  
   `git push origin main --force`

2. **If GitHub blocks the push** (secret detected in history): You will (a) open the email or repo Security tab and use **Unblock** for the detected secret, and (b) **rotate** the exposed Shopify app secret in Shopify Admin and update `.env.local`. Reply **"Approved"** or **"Yes"** to confirm you’ll do that so we can push again.

Once you’ve replied with approval, the agent can run the force-push (and, if needed, a second push after you’ve unblocked and rotated).

**If push was blocked by GitHub (secret detected):**

1. **Unblock the secret**: Open this URL and click to allow the push:  
   https://github.com/toodeceptive/against-the-odds/security/secret-scanning/unblock-secret/38xq5YftGtS6MNaAcw3DXsAnnnp
2. **Rotate the exposed Shopify App Shared Secret** in Shopify Admin (Apps → Your app → API credentials → regenerate Client secret). Update `.env.local` with the new secret.
3. Tell the agent “Done” or “Push again”; the agent will run `git push origin main --force` again.

---

## Blocker Resolution Checklist

- [x] **2a.** History cleaned (git-filter-repo) + credentials rotated
- [ ] **2b.** Remote renames done (by you) + local fetch/merge done (if needed)
- [x] **Push** succeeds (main force-pushed 2026-01-29)

---

## 2a. GitHub Push Protection

**Cause:** Historical commits contain exposed Shopify App Shared Secret (`shpss_...`). Current files are sanitized; GitHub scans full history.

### Option A (Preferred): Remove secret from history with git filter-repo

**Prerequisites:** Install [git-filter-repo](https://github.com/newren/git-filter-repo) (e.g. `pip install git-filter-repo` or use Windows package manager). Create a fresh clone or backup before rewriting.

1. **Create a replace-text file** (no secret inside). Example `replacements.txt`:

   ```
   shpss_==>PLACEHOLDER_SHOPIFY_SECRET
   ```

   (Use the exact placeholder you want in history.)

2. **Run filter-repo** from repo root (rewrites history; destructive):

   ```powershell
   cd C:\Users\LegiT\against-the-odds
   git filter-repo --replace-text replacements.txt --path .env.example --path scripts/setup/auto-configure-env.ps1 --path-glob '*.md' --force
   ```

   Or use `--invert-paths` if you prefer to only touch specific paths; adjust paths to match every file that ever contained the secret (see report: `.env.example`, `NEXT_STEPS.md`, `COMPLETION_REPORT.md`, `docs/ENVIRONMENT_SETUP.md`, `scripts/setup/auto-configure-env.ps1`). Check git-filter-repo docs for `--replace-text` and path options.

3. **Rotate credentials** in Shopify (Admin → Apps → Your app → API credentials): regenerate Client secret / Shared secret. Update `.env.local` with new values (never commit).

4. **Force-push** (only after you have approved and completed steps 1–3):
   ```powershell
   git push origin finalization/consolidate-20260129 --force
   ```
   If the branch is protected, temporarily allow force-push in GitHub repo Settings → Branches, then push, then restore protection.

### Option B (Alternative): GitHub unblock flow

1. Push as usual; when GitHub blocks, open the email or the repo Security tab and use **“Unblock”** / **“Allow secret”** for the detected secret.
2. **Immediately** rotate the exposed credentials in Shopify and update `.env.local`.
3. Push again; it should succeed. (Secret remains in history but is rotated.)

---

## 2b. Windows-Invalid Filenames on origin/main

**Cause:** Two files on `origin/main` have `\"` in the name; invalid on Windows.

### What you do (remote)

**Option A — GitHub web UI**

1. Open the repo on GitHub → main branch.
2. Find and open:
   - `A_collection_of_eight_\"AO\"_logo_designs_is_arrange.png`
   - `A_set_of_eight_\"AO\"_logo_variations_are_arranged_i.png`
3. For each: use “Edit”/rename or delete. Suggested new names:
   - `A_collection_of_eight_AO_logo_designs_is_arrange.png`
   - `A_set_of_eight_AO_logo_variations_are_arranged_i.png`
4. Commit the renames (or deletions) on `main` via the GitHub UI.

**Option B — Linux/Mac clone**

```bash
git clone <repo-url> against-the-odds-fix && cd against-the-odds-fix
git checkout main
git mv "A_collection_of_eight_\"AO\"_logo_designs_is_arrange.png" "A_collection_of_eight_AO_logo_designs_is_arrange.png"
git mv "A_set_of_eight_\"AO\"_logo_variations_are_arranged_i.png" "A_set_of_eight_AO_logo_variations_are_arranged_i.png"
git add -A && git commit -m "fix: rename Windows-invalid PNG filenames (remove quotes)"
git push origin main
```

### What to run locally (after remote renames are on origin/main)

From the primary repo on branch `finalization/consolidate-20260129` (or after merging to `main`):

```powershell
cd C:\Users\LegiT\against-the-odds
git fetch origin
git merge origin/main
# Resolve any merge conflicts if they appear; then:
# git add -A && git commit -m "merge origin/main after remote filename fix"
```

If you prefer to integrate via main first:

```powershell
git checkout main
git pull origin main
git checkout finalization/consolidate-20260129
git merge main
# Resolve conflicts if any, then commit.
```

---

## Order of operations

1. Resolve **2b** first (remote renames + local fetch/merge) so that `origin/main` has no Windows-invalid paths.
2. Resolve **2a** (history cleanup or unblock + credential rotation).
3. Push `finalization/consolidate-20260129` (or `main` after merge) and confirm no push protection errors.
