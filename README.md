# rh-aiservices-bu/cai

Team page for the **Customer Adoption & Innovation (CAI)** team, Red Hat AI Business Unit.
Built with [Hugo](https://gohugo.io/) and the [OINK](https://github.com/pgsty/oink) theme,
deployed to GitHub Pages at https://rh-aiservices-bu.github.io/cai/.

## Preview locally

Requires Hugo Extended ≥ 0.165 and Go ≥ 1.27 (no Node.js):

```sh
hugo server
```
Serves under the baseURL subpath — open http://localhost:1313/cai/ (a 404 at the root is expected).

## Deploy

1. Repo **Settings → Pages → Source: GitHub Actions** (one-time).
2. Push to `main`, or run **Deploy to GitHub Pages** from the Actions tab.

The workflow (`.github/workflows/github-pages.yaml`) pins Hugo 0.165.0, resolves the
OINK module from `go.mod`/`go.sum`, and builds warning-strict.

## Content map

| Path | What it is |
| --- | --- |
| `data/home/en.yaml` | Landing page sections (hero, metrics, initiative cards, mission, team, engage CTA) |
| `content/_index.md` | Home page front matter (title, description) |
| `hugo.yaml` | The only site configuration file |
