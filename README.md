# rh-aiservices-bu/cai

Team page for the **Customer Adoption and Innovation (CAI)** team, Red Hat AI Business Unit.
Built with [Hugo](https://gohugo.io/) and the [OINK](https://github.com/pgsty/oink) theme,
deployed to GitHub Pages at https://rh-aiservices-bu.github.io/cai/.

## Preview locally

Requires Hugo Extended ≥ 0.165 and Go ≥ 1.27 (no Node.js):

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

The workflow (`.github/workflows/github-pages.yaml`) pins Hugo 0.165.0, resolves the
OINK module from `go.mod`/`go.sum`, and builds warning-strict.

## Content map

| Path | What it is |
| --- | --- |
| `data/home/en.yaml` | Landing page sections (hero, metrics, initiative cards, tutorials, mission, team, get-started CTA) |
| `data/home/fr.yaml` | French landing sections; `es/de/sv/it/tr` peers in the same folder (resolved per language by the theme; hero title and brand name stay English) |
| `content/_index.md` | Home page front matter (title, description) |
| `content/_index.fr.md` | French home page front matter; `es/de/sv/it/tr` peers in the same folder |
| `i18n/en.yaml` | English strings: landing left-nav rail labels |
| `i18n/fr.yaml` | French strings: left-nav rail labels + translations for OINK UI strings the theme ships as English fallbacks; `es-ES/de-DE/sv-SE/it-IT/tr-TR` peers named by full subtag so project strings register after the theme's base-tag fallbacks and always win |
| `hugo.yaml` | The only site configuration file |
