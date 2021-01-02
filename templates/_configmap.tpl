#
# ConfigMap handling
#

{{- define "template.configmap.name" -}}
{{ include "template.name" . }}-config
{{- end }}

{{- define "template.configmap.file.list" -}}
{{- $folders := dict -}}
{{- range $path, $_ := .Files.Glob "files/*/*" -}}
  {{- if ne "." ($path | base | substr 0 1) -}}
    {{- $folder := $path | dir | base | printf "-%s" -}}
    {{- $files := hasKey $folders $folder | ternary (get $folders $folder) list -}}
    {{- $files = append $files $path -}}
    {{- $folders = set $folders $folder $files -}}
  {{- end -}}
{{- end -}}
{{- $folders | toJson -}}
{{- end -}}

{{- define "template.configmap.file.exist" -}}
{{- $folders := include "template.configmap.file.list" .context | fromJson -}}
{{- if not (hasKey $folders (printf "-%s" .name)) -}}
  {{- printf "The folder \"files/%s\" is unknown" .name | fail -}}
{{- end -}}
{{- end -}}

{{- define "template.configmap.env.chart" -}}
- configMapRef:
    name: {{ include "template.configmap.name" . }}
{{- end -}}
