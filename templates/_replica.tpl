#
# Replica handling
#

{{- define "template.replica.default" -}}
{{ .default | default 1 }}
{{- end }}

{{- define "template.replica.check" -}}
  {{- if or .min .max -}}
    {{- $default := (include "template.replica.default" .) | int -}}
    {{- if .min -}}
      {{- if gt (.min | int) $default -}}
        {{- printf "The minimum of the replicas (%v) must be less than or equal to the default value (%v)" .min $default | fail -}}
      {{- end -}}
    {{- end -}}
    {{- if .max -}}
      {{- if lt (.max | int) $default -}}
        {{- printf "The maximum of the replicas (%v) must be greater than or equal to the default value (%v)" .max $default | fail -}}
      {{- end -}}
    {{- end -}}
    {{- true -}}
  {{- end -}}
{{- end }}
