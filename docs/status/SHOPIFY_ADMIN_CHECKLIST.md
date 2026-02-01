# Shopify Admin verification checklist

**Purpose:** When you log into Shopify Admin (https://aodrop.com/admin), verify these so theme setup and GitHub integration are correct. The agent cannot log in for you; use this list when you open Admin in your browser.

---

## 1. Online store → Themes

- [ ] Live theme is the one you expect (e.g. Dawn or your custom theme).
- [ ] If you use GitHub deploy: the theme connected to the repo is the one shown or deployed from the connected branch (e.g. `main` or `shopify-theme`).
- [ ] No broken or duplicate theme entries.

---

## 2. Settings → Apps and sales channels

- [ ] **GitHub** (or “Shopify GitHub integration”) is installed if you deploy from GitHub.
- [ ] Connected repository: `toodeceptive/against-the-odds` (or your fork).
- [ ] Branch set correctly (e.g. `main` or `shopify-theme`).
- [ ] Theme path/directory matches your repo (e.g. `src/shopify/themes/aodrop-theme` if the app asks).

---

## 3. Settings → Users and permissions

- [ ] Your account (e.g. legitp@gmail.com) is **Store owner** or **Staff** with **Online store** (themes) access so theme pull/push and CLI work.
- [ ] No duplicate or obsolete staff accounts you want removed.

---

## 4. Settings → Domains

- [ ] Primary domain is correct (e.g. aodrop.com).
- [ ] No unintended redirects or duplicate domains.

---

## 5. Apps → Development (if you use custom app / API token)

- [ ] Development app exists and has **Read/Write** access to **Themes** (and **Products** if you sync products).
- [ ] API credentials (Admin API access token) match what you use in `.env.local` (SHOPIFY_ACCESS_TOKEN / SHOPIFY_CLI_THEME_TOKEN) if you use token-based theme pull.

---

**After verification:** If anything is wrong, fix it in Admin; then re-run theme-pull or theme-update-store as needed. See [UPDATE_SHOPIFY_FROM_CURSOR.md](../UPDATE_SHOPIFY_FROM_CURSOR.md) and [MANUAL_VERIFICATION_CHECKLIST.md](MANUAL_VERIFICATION_CHECKLIST.md).
