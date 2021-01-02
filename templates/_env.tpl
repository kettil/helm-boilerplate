#
# ENV handling
#

{{- define "template.env.key" -}}
{{- $ | snakecase | upper -}}
{{- end -}}

{{- define "template.env.chart" -}}
{{- if .env -}}
  {{- include "template.env.global" .env -}}
{{- end -}}
{{- end -}}

{{- define "template.env.global" -}}
{{- range $name, $value := . -}}
- name: {{ include "template.env.key" $name }}
  value: {{ $value | quote }}
{{ end }}
{{- end -}}

{{- define "template.env.secret" -}}
- secretRef:
    name: {{ include "template.secret.name" .context }}-env-{{ .name }}
{{- end -}}
