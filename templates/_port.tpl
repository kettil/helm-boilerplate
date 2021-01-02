#
# Port handling
#

{{- define "template.port.name" -}}
port-{{ .name }}
{{- end }}

{{- define "template.port.list" -}}
{{- $groups := dict -}}
{{- range $port := .Values.ports -}}
  {{- if $port.enabled -}}
    {{- $type := $port.portType | default "ClusterIP" -}}
    {{- $ports := hasKey $groups $type | ternary (get $groups $type) list -}}
    {{- $ports := append $ports $port -}}
    {{- $groups := set $groups $type $ports -}}
  {{- end -}}
{{- end -}}
{{- $groups | toJson -}}
{{- end -}}

{{- define "template.port.service" -}}
{{- range $port := .ports -}}
- name: {{ include "template.name" $.context }}-service-{{ include "template.port.name" $port }}
  protocol: {{ $port.protocol | default "TCP" }}
  port: {{ $port.port }}
  targetPort: {{ include "template.port.name" $port }}
  {{- if $port.nodePort }}
  nodePort: {{ $port.nodePort }}
  {{- end }}
{{ end -}}
{{- end -}}

{{- define "template.port.container" -}}
{{- if .enabled -}}
- name: {{ include "template.port.name" . }}
  protocol: {{ .protocol | default "TCP" }}
  containerPort: {{ .port }}
{{- else -}}
# port {{ .port }} [{{ .name }}] is disabled
{{- end }}
{{- end }}

{{- define "template.port.ingress" -}}
{{- range $port := .Values.ports -}}
{{- if and $port.enabled $port.ingressPath $port.ingressType -}}
- path: {{ $port.ingressPath }}
  pathType: {{ $port.ingressType }}
  #host: localhost
  backend:
    service:
      name: {{ include "template.name" $ }}-service-{{ $port.portType | default "ClusterIP" | lower }}
      port:
        name: {{ include "template.port.name" $port }}
{{ end }}
{{- end }}
{{- end }}
