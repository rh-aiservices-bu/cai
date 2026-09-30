{{- /* Semantic Markdown body of the home landing: title, description, then the
data-driven sections (data/home/<lang>.yaml) rendered by the theme's
landing/text.html serializer. Shared by layouts/all.md (per-page markdown
output) and layouts/index.llmsfull.txt (home full-text bundle) so the two
outputs cannot drift. Context is the home page. The .md extension is
load-bearing: an .html partial would run under html/template autoescaping
and entity-escape the Markdown it emits. */ -}}
# {{ .Title | strings.TrimSpace }}
{{- with .Description | strings.TrimSpace }}

> {{ replace . "\n" "\n> " }}
{{- end }}
{{- $landing := partial "landing/home-data.html" . -}}
{{- with (partial "landing/text.html" (dict "page" . "data" $landing) | strings.TrimSpace) }}

{{ . | safeHTML }}
{{- end -}}
