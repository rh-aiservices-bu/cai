# rh-aiservices-bu/cai

Team page for the **Customer Adoption and Innovation (CAI)** team, Red Hat AI Business Unit.
Built with [Hugo](https://gohugo.io/) and the [OINK](https://github.com/pgsty/oink) theme,
deployed to GitHub Pages at https://rh-aiservices-bu.github.io/cai/.

## Preview locally

Requires Hugo Extended ≥ 0.169.0 and Go ≥ 1.27.3 (no Node.js):

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

The workflow (`.github/workflows/github-pages.yaml`) pins Hugo 0.169.0, resolves the
OINK v1.5.1 module from `go.mod`/`go.sum`, and builds via `hugo --printPathWarnings`.

## Content map

| Path | What it is |
| --- | --- |
| `data/home/en.yaml` | Landing page sections (hero, metrics, initiative cards, tutorials, mission, team, get-started CTA) |
| `data/home/fr.yaml` | French landing sections; `es/de/sv/it/tr/ga` peers in the same folder (resolved per language by the theme; hero title and brand name stay English) |
| `content/_index.md` | Home page front matter (title, description) |
| `content/_index.fr.md` | French home page front matter; `es/de/sv/it/tr/ga` peers in the same folder |
| `i18n/de.yaml` / `i18n/es.yaml` / `i18n/fr.yaml` / … (plus `i18n/en.yaml`) | Per-locale UI strings: landing rails + OINK appearance/preset, shell, copy/link, 404. Bare `<lang>.yaml` so entries merge on top of theme `<lang>.yaml` (regioned names like `de-DE.yaml` shadow instead of merging, see `ef9f1e6`). `nav_contents` stays commented out site-wide |
| `hugo.yaml` | The only site configuration file |
