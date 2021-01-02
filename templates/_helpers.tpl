#
# Global templates
#

{{- define "template.name" -}}
{{ $.Release.Name }}-{{ $.Chart.Name | kebabcase }}
{{- end }}

{{- define "template.labels" -}}
app.kubernetes.io/name: {{ include "template.name" . }}
{{- if $.Values.global.labels.project }}
app.kubernetes.io/part-of: {{ $.Values.global.labels.project }}
{{- end }}
app.kubernetes.io/instance: {{ $.Release.Name }}
app.kubernetes.io/component: {{ $.Chart.Name }}
app.kubernetes.io/managed-by: {{ $.Release.Service }}
app.kubernetes.io/version: {{ $.Chart.AppVersion }}
helm.sh/chart: {{ $.Chart.Name }}-{{ $.Chart.Version | replace "+" "_" }}
{{- range $key, $value := omit $.Values.global.labels "project" }}
{{ $key }}: {{ $value }}
{{- end -}}
{{- end -}}
