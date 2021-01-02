#
# Probe handling
#

{{- define "template.probe" -}}
{{- range $type, $data := $.container.probes -}}
{{ $type }}Probe:
  {{- include "template.probe.settings" $data | nindent 2 }}
  {{- if eq "httpGet" $data.type }}
    {{- include "template.probe.types.http" (dict "context" $.context "spec" $data.spec) | nindent 2 }}
  {{- else if eq "tcpSocket" $data.type }}
    {{- include "template.probe.types.tcp" (dict "context" $.context "spec" $data.spec) | nindent 2 }}
  {{- else if eq "exec" $data.type }}
    {{- include "template.probe.types.exec" (dict "context" $.context "spec" $data.spec) | nindent 2 }}
  {{- else }}
    {{- printf "The probe type \"%s\" is unknown" $data.type | fail }}
  {{- end }}
{{ end }}
{{- end }}

{{- define "template.probe.types.http" -}}
httpGet:
  scheme: HTTP
  port: {{ include "template.port.name" (get .context.Values.ports .spec.port) }}
  path: {{ .spec.path }}
  httpHeaders: {{ .spec.headers | toYaml | nindent 4 }}
{{- end }}

{{- define "template.probe.types.tcp" -}}
tcpSocket:
  port: {{ include "template.port.name" (get .context.Values.ports .spec.port) }}
{{- end }}

{{- define "template.probe.types.exec" -}}
exec:
  command: {{ eq (typeOf .spec.command) "string"  | ternary .spec.command (.spec.command | toYaml | nindent 4) }}
{{- end }}

{{- define "template.probe.settings" -}}
{{- if .initialDelaySeconds -}}
initialDelaySeconds: {{ .initialDelaySeconds }}
{{- end }}
{{- if .initialDelaySeconds }}
periodSeconds: {{ .periodSeconds }}
{{- end }}
{{- if .timeoutSeconds }}
timeoutSeconds: {{ .timeoutSeconds }}
{{- end }}
{{- if .successThreshold }}
successThreshold: {{ .successThreshold }}
{{- end }}
{{- if .failureThreshold }}
failureThreshold: {{ .failureThreshold }}
{{- end }}
{{- end }}
