# Handover: Improve rh-aiservices-bu/cai GitHub Pages Team Page

## Context
- **Repo:** `https://github.com/rh-aiservices-bu/cai` (branch `redesign`, default branch `main`)
- **Team:** Customer Adoption & Innovation (CAI), Red Hat AI Business Unit
- **Target audience:** External (customers, partners)
- **Director:** @erwangranger (user)

## Decisions Made
1. **Site migrated Jekyll → Hugo + `pgsty/oink` theme** (Apache-2.0). Pinned via `go.mod`/`go.sum`; config in `hugo.yaml` only. Deploys via `.github/workflows/github-pages.yaml` (starter pattern, warning-strict build, triggers on push to `main`).
2. **Jekyll files removed:** `_config.yml` deleted; `about.md` moved to `content/about/_index.md` (since merged into the landing page); `README.md` rewritten as repo readme (build/deploy instructions).
3. **Red Hat look applied (no company logo):** `$primary: #ee0000` in `assets/scss/_variables_project.scss`; fonts (Red Hat Display / Text / Mono, variable woff2, latin) vendored in `static/webfonts/` with `@font-face` + font-role overrides in `assets/scss/_styles_project.scss`; brand layer pairs `--td-brand-copper` #ee0000 light / #ff6666 dark; canvas overrides scoped `[data-bs-theme='light']` only (plain `:root` ties the dark palette on specificity and leaks); `.td-site-header .td-nav-logo` hidden — site name is the wordmark.
4. **Single-page merge (director request: one scrollable page with left nav):** `content/team/` and `content/about/` deleted; all content merged into the landing page via `data/home/en.yaml` native sections — hero, cards, `mission` (markdown: old "What we do" bullets), `team` (`contributors` type: avatar + name + GitHub/LinkedIn links per member, 3 columns), `about` (markdown: Team API sentence), cta.
5. **Left navigation rail:** `layouts/_partials/hooks/body-end.html` injects a fixed "Contents" nav (home only) with anchor links to each section; `assets/js/landing-nav.js` is a self-contained IntersectionObserver scroll-spy (active link highlight); `assets/css/landing-sidebar.css` styles the 220px fixed rail below the sticky header, content offset via `margin-inline-start`, `scroll-margin-top` on anchors, rail folds away below `lg`.
6. **Native theme sections only:** no custom section registry override; `sections` entries for non-type keys use map form (`- type: markdown, key: mission`) because bare string entries resolve the section type from the key name (registered types only).

## Pending Items

### 1. LinkedIn URLs — confirmed by director, rendered on landing team grid
| Member | LinkedIn URL | Status |
|---|---|---|
| guimou | `linkedin.com/in/guillaume-moutier-70aba762` | Added |
| erwangranger | `linkedin.com/in/erwangranger` | Added |
| keklundrh | `linkedin.com/in/karl-eklund-a2180515` | Added |
| deewhyweb | `linkedin.com/in/philip-hayes-0327532` | Added (medium confidence) |
| rcarrata | `linkedin.com/in/rcarrata` | Added |
| RHRolun | `linkedin.com/in/rolun` | Added (medium-high) |
| ckavili | `linkedin.com/in/ckavili` | Added |
| abanderb (sarabanderby) | none found | No link |
| willsparker | none found | No link |

### 2. Display names — applied
- `RHRolun` → Robert Lundberg (cross-ref via Hugging Face profile)
- `ckavili` → Cansu Kavili Örnek (Red Hat author page)
- Remaining first-name-only: Sara (abanderb)

### 3. One-time deploy step (admin)
Repo **Settings → Pages → Source: GitHub Actions** must be selected before first deploy; then push `main` or run "Deploy to GitHub Pages" from Actions tab.

### 4. Future work
- Flesh out Team API operating model (how work is taken, response expectations).
- About page content merged into the landing Team API section; further content unchanged.

## Verification (done)
- Production build warning-strict: PASS (11 pages, 25 static files).
- Render check (headless browser, localhost:4173/cai/): fixed 220px left rail (6 links, top=50 below sticky header), all 6 sections, 9 contributor cards with avatars, anchor click clears header (about at y≈140), scroll-spy activates the section crossing the reading band, content offset 220px — zero console/page errors.
- Live site check pending first deploy to `https://rh-aiservices-bu.github.io/cai/`.
