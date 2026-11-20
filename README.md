# rh-aiservices-bu/cai

Team page for the **Customer Adoption and Innovation (CAI)** team, Red Hat AI Business Unit.
Built with [Hugo](https://gohugo.io/) and the [OINK](https://github.com/pgsty/oink) theme,
deployed to GitHub Pages at https://rh-aiservices-bu.github.io/cai/.

## Preview locally

Requires Hugo Extended 0.169.0 and Go ≥ 1.27.3 (no Node.js): OINK declares `min_version 0.168.0` but only 0.169.0 was ever built here; 0.170+ drops libsass and breaks OINK's SCSS `toCSS` build.

```sh
hugo server
```
Serves under the baseURL subpath — open http://localhost:1313/cai/ (a 404 at the root is expected).

Or control the render in the background (idempotent start/stop, busy-port and stale-pid hints):

```sh
scripts/render.sh start|stop|restart|status|logs [n]|follow
```

## Deploy

1. Repo **Settings → Pages → Source: GitHub Actions** (one-time).
2. Push to `main`, or run **Deploy to GitHub Pages** from the Actions tab.

The workflow (`.github/workflows/github-pages.yaml`) pins Hugo 0.169.0, fetches the
`github.com/pgsty/oink` module pinned in `go.mod` at v1.5.1 (+ `go.sum`), and builds with `hugo --printPathWarnings` (no `--panicOnWarning` — upstream OINK/OINK-starter also omit it).

## Bilingual (Duo View)

OINK **Duo View** shows two translations of the same page side-by-side in the
browser (on-demand, same origin, no extra outputs). It works out of the box on
`docs`/`book`/`blog` pages; our landing (`kind: home`, `_index.md`) needs extra
wiring because of two upstream gates.

**Flag** (necessary but not sufficient on the landing):

```yaml
# hugo.yaml — turn the feature on
params:
  ui:
    compare: true
```

**Landing wiring still TODO** — `compare/targets.html:12` gates on
`(in (slice "docs" "book" "blog") .Type)` so the home page returns no targets
(no `td-compare-config`, no palette action, no entry button). A project shadow
of that partial admitting `kind: home`/`type: page` — keeping the same-origin,
`.Translations` and `enabled` checks — plus injecting `compare/entry.html`
into the landing shell (e.g. the existing `body-end.html` rail hook or
`layouts/_partials/landing/...`) is required to make Duo View live here.
Contributions welcome; without that, `compare: true` alone does nothing.

## Content map

| Path | What it is |
| --- | --- |
| `data/home/en.yaml` | Landing page sections (hero, metrics, initiative cards, tutorials, mission, team, get-started CTA) |
| `data/home/fr.yaml` | French landing sections; `es/de/sv/it/tr/ga` peers in the same folder (resolved per language by the theme; hero title and brand name stay English) |
| `content/_index.md` | Home page front matter (title, description) |
| `content/_index.fr.md` | French home page front matter; `es/de/sv/it/tr/ga` peers in the same folder |
| `i18n/de.yaml` / `i18n/es.yaml` / `i18n/fr.yaml` / … (`i18n/en.yaml` too) | Site-specific UI: landing rail (`nav_*`), appearance/preset (`ui_appearance*`/`ui_preset_*`), dark-mode, copy/link, shell (search + drawer/nav + nav switcher), 404. Bare `<lang>.yaml` so entries merge on top of theme `<lang>.yaml` (e.g. `de-DE.yaml` would shadow instead of merging). `nav_contents` is intentionally commented out site-wide — its 8 `MISSING_TRANSLATION` warn only under `hugo --printI18nWarnings` |
| `hugo.yaml` | The only site configuration file |
