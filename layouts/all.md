{{- /* Per-page semantic Markdown output. The home page carries its content in
data-driven landing sections (data/home/<lang>.yaml), not .RawContent, so it
renders through the theme's landing text serializer; every other page keeps
the shared markdown-document renderer. Project override of the theme's
layouts/all.md. */ -}}
{{- .Page.Store.Set "tdOutputFormat" "markdown" -}}
{{- if .IsHome -}}
  {{- partial "landing/home-text.md" . -}}
{{- else -}}
  {{- partial "content/markdown-document.md" . -}}
{{- end -}}
