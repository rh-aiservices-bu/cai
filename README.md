# rh-aiservices-bu/cai

Team page for the **Customer Adoption and Innovation (CAI)** team, Red Hat AI Business Unit.
Built with [Hugo](https://gohugo.io/) and the [OINK](https://github.com/pgsty/oink) theme,
deployed to GitHub Pages at https://rh-aiservices-bu.github.io/cai/.

## Preview locally

Requires Hugo Extended 0.168.0–0.169.x and Go ≥ 1.27.3 (no Node.js): 0.170+ drops libsass and breaks OINK's SCSS build (CI pins 0.169.0).

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
`github.com/pgsty/oink` module pinned in `go.mod` at v1.5.1 (+ `go.sum`), and builds with `hugo --printPathWarnings` (no `--panicOnWarning` — upstream OINK also omits it; `oink-starter` runs at 0.168.0).

## Content map

| Path | What it is |
| --- | --- |
| `data/home/en.yaml` | Landing page sections (hero, metrics, initiative cards, tutorials, mission, team, get-started CTA) |
| `data/home/fr.yaml` | French landing sections; `es/de/sv/it/tr/ga` peers in the same folder (resolved per language by the theme; hero title and brand name stay English) |
| `content/_index.md` | Home page front matter (title, description) |
| `content/_index.fr.md` | French home page front matter; `es/de/sv/it/tr/ga` peers in the same folder |
| `i18n/de.yaml` / `i18n/es.yaml` / `i18n/fr.yaml` / … (`i18n/en.yaml` too) | Site-specific UI: landing rail (`nav_*`), appearance/preset (`ui_appearance*`/`ui_preset_*`), dark-mode, copy/link, shell (search + drawer/nav + nav switcher), 404. Bare `<lang>.yaml` so entries merge on top of theme `<lang>.yaml` (regioned names like `de-DE.yaml` shadow instead of merging, see `ef9f1e6`). `nav_contents` intentionally commented out site-wide — the 8 warnings it emits are harmless |
| `hugo.yaml` | The only site configuration file |
