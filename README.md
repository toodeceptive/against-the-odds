# Against the Odds

Official Against the Odds (AO) brand website and store. This repository is the
main project workspace for the AO digital presence, brand story, and future
commerce experience.

## Project overview

- **Static preview:** `index.html` + `styles.css`
- **Shopify theme:** `shopify-theme/` (Online Store 2.0 sections)
- **Brand assets:** AO logo explorations and mark studies in the root directory
- **Next focus:** finalize the hero mark and publish storefront content

## Local preview

You can open the site directly in a browser, or run a simple static server:

```bash
python -m http.server 8080
```

Then visit `http://localhost:8080`.

## Shopify theme workflow

This repo includes a Shopify theme that mirrors the main site layout. To deploy
it automatically via GitHub Actions:

1. Create a **Theme Access** token (Shopify Admin → Apps → Theme Access).
2. Find the **Theme ID** you want to deploy to.
3. Add GitHub repository secrets:
   - `SHOPIFY_CLI_THEME_TOKEN` (Theme Access token)
   - `SHOPIFY_STORE_DOMAIN` (your `*.myshopify.com` store domain)
   - `SHOPIFY_THEME_ID` (numeric theme ID)
4. Run the **Deploy Shopify theme** workflow or push to `main`.

The workflow is gated and will only run when all secrets are present.

## Domain status checklist

- Set the primary domain in Shopify (choose `aodrop.com` or `www.aodrop.com`).
- Keep Cloudflare DNS records pointing to Shopify as configured.
- If TLS provisioning stalls for more than 48 hours, retry domain verification
  inside Shopify.
