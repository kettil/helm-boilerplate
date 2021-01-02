#
# Secret handling
#

{{/* Name handling for the secret context */}}
{{- define "template.secret.files.name" -}}
{{ $.Release.Name }}-files
{{- end -}}

{{/* Name handling for the secret context */}}
{{- define "template.secret.env.name" -}}
{{ $.Release.Name }}-env
{{- end -}}

{{/* Name handling for the chart context */}}
{{- define "template.secret.name" -}}
{{ $.Release.Name }}-{{ $.Values.global.secretPostfix }}
{{- end -}}
