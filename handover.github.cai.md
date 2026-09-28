# Handover: Improve rh-aiservices-bu/cai GitHub Pages Team Page

## Context
- **Repo:** `https://github.com/rh-aiservices-bu/cai` (branch `redesign`, default branch `main`)
- **Team:** Customer Adoption & Innovation (CAI), Red Hat AI Business Unit
- **Target audience:** External (customers, partners)
- **Director:** @erwangranger (user)

## Decisions Made
1. **Site migrated Jekyll → Hugo + `pgsty/oink` theme** (Apache-2.0). Pinned via `go.mod`/`go.sum`; config in `hugo.yaml` only. Deploys via `.github/workflows/github-pages.yaml` (starter pattern, warning-strict build, triggers on push to `main`).
2. **Jekyll files removed:** `_config.yml` deleted; `about.md` moved to `content/about/_index.md` (since merged into the landing page); `README.md` rewritten as repo readme (build/deploy instructions).
3. **Red Hat look applied (no company logo):** `$primary: #ee0000` in `assets/scss/_variables_project.scss`; fonts (Red Hat Display / Text / Mono, variable woff2, latin) vendored in `static/webfonts/` with `@font-face` + font-role overrides in `assets/scss/_styles_project.scss`; brand layer pairs `--td-brand-copper` #ee0000 light / #ff6666 dark; canvas overrides scoped `[data-bs-theme='light']` only (plain `:root` ties the dark palette on specificity and leaks); `.td-site-header .td-nav-logo` hidden — site name is the wordmark. **Header bg theme-scoped (dark-mode header bug report):** `--td-brand-header-bg` white band moved from `:root` to `:root[data-bs-theme='light']` (a `:root` definition cascades into dark mode), dark block defines the theme's near-black `rgba(11,17,25,0.92)` — dark header now blends with the page.
4. **Single-page merge (director request: one scrollable page with left nav):** `content/team/` and `content/about/` deleted; all content merged into the landing page via `data/home/en.yaml` native sections — hero, metrics, cards, `mission` (markdown: old "What we do" bullets), `team` (`contributors` type: avatar + name + GitHub/LinkedIn links per member, 3 columns), cta. Team API section removed at director request (`8904455` + follow-up).
5. **Landing polish (director request from oink-intro review):** hero gains light/dark network SVG (`static/landing/hero-{light,dark}.svg`, `media.hide_below: lg`), 3 nowrap-safe title lines with "(CAI)" marked `color: red` (`title_size: 2.8rem` — oink title spans are `white-space: nowrap`; one long line overflows the split column), punchy lead + "customer zero" note; new animated `metrics` band (178/96/4/9, each with `source {label, url}`; members source anchors to `#team`, not `team/` — `content/team/` no longer exists); CTA upgraded from one button to a 3-action array (primary + 2 ghost, all `external: true`). Hero action anchors to `#team` (was `team/`).
6. **Native theme sections only:** no custom section registry override; `sections` entries for non-type keys use map form (`- type: markdown, key: mission`) because bare string entries resolve the section type from the key name (registered types only).
7. **Initiative cards fully clickable, new tab (director request):** `external: true` on each `cards` item in `data/home/en.yaml` (the theme's action partial then renders `target="_blank" rel="noopener noreferrer"`); whole-card overlay via `_styles_project.scss` replicating the theme's logo-tile pattern (`.td-landing-card { position: relative }` + card link `::after { position: absolute; inset: 0 }`, card-traced focus ring).
8. **Landing brand retints** (`assets/scss/_styles_project.scss`, loaded after the theme so same-specificity later wins): `.td-landing-initial--red` retinted to `var(--td-brand-copper)` (oink's `--red` is terracotta #cf4439); `.td-landing-button--primary` retinted from oink's hard-coded blue #2f6793 to the brand pair, with per-theme hover tones `--td-brand-primary-hover` #be0000 light / #ff8585 dark. Rail in `layouts/_partials/hooks/body-end.html` gains a "Numbers" → `#metrics` link, ordered to match page sections.
9. **Off-brand leftover (user decision):** `static/favicon.svg` and the shell's `assets/icons/logo.svg` fallback are the starter's blue placeholder art (`#245f94`). `logo.svg` is load-bearing (`shell/config.html` defaults `logo: icons/logo.svg`) — do not delete. Both are invisible on the page (nav logo hidden) except the browser-tab favicon, which shows the blue mark.

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
Repo **Settings → Pages → Source: GitHub Actions** must be selected before first deploy; the Pages workflow triggers on push to `main`, so deploying also needs `redesign` merged/pushed to `main` (or run "Deploy to GitHub Pages" from the Actions tab after that merge).

### 4. Future work
- Landing content is final for now; further page content unchanged since the merge.

## Verification (done)
- Copyright line removed from the footer at director request (no © held): `params.copyright` deleted from `hugo.yaml`; the theme's footer/copyright partial falls through to unset `Site.Copyright` and renders nothing — no © year, authors, or "All Rights Reserved" text.
- Production build warning-strict: PASS (11 pages, 27 static files, 689 ms, zero warnings).
- Render check (headless browser, localhost:1313/cai/ at 1440px): fixed left rail (6 links: Home, Numbers, Initiatives, Mission, Team, Engage), 6 sections — hero (media + 3 nowrap-safe title lines, "(CAI)" in brand red), animated sourced metrics band (178/96/4/9), 4 clickable initiative cards, mission, 9-person team grid (GitHub+LinkedIn desc links, avatars), 3-action CTA — light and dark, zero render errors. Primary landing button and marked word render #ee0000/#ff6666 per theme.
- Live site check pending first deploy to `https://rh-aiservices-bu.github.io/cai/`.
