#
# Volume handling
#

{{- define "template.volume.name" -}}
{{ include "template.name" . }}-volume
{{- end -}}

{{/* #################### */}}

{{/* Volume definition: ConfigMap */}}
{{- define "template.volume.config" -}}
{{- include "template.configmap.file.exist" . -}}
- name: {{ include "template.volume.name" .context }}-{{ .name }}
  configMap:
    name: {{ include "template.configmap.name" .context }}-{{ .name }}
{{- end -}}

{{/* Volume definition: Secret */}}
{{- define "template.volume.secret" -}}
- name: {{ include "template.volume.name" .context }}-secrets-{{ .name }}
  secret:
    secretName: {{ include "template.secret.name" .context }}-files-{{ .name }}
{{- end -}}

{{/* #################### */}}

{{/* Definition of the mount point for the folder: ConfigMap */}}
{{- define "template.volume.config.mount" -}}
{{- include "template.configmap.file.exist" . -}}
{{- include "template.volume.mount._" . -}}
{{- end -}}

{{/* Definition of the mount point for a single file: ConfigMap */}}
{{- define "template.volume.config.file" -}}
{{- include "template.configmap.file.exist" . -}}
{{- include "template.volume.mount._" . }}
  subPath: {{ .mount | base }}
{{- end -}}

{{/* Definition of the mount point for the folder: Secret */}}
{{- define "template.volume.secret.mount" -}}
{{- $name := printf "secrets-%s" .name -}}
{{- include "template.volume.mount._" (mergeOverwrite . (dict "name" $name)) -}}
{{- end -}}

{{/* Definition of the mount point for a single file: Secret */}}
{{- define "template.volume.secret.file" -}}
{{- $name := printf "secrets-%s" .name -}}
{{- include "template.volume.mount._" (mergeOverwrite . (dict "name" $name)) }}
  subPath: {{ .mount | base }}
{{- end -}}

{{/* Global definition of the mount point */}}
{{- define "template.volume.mount._" -}}
- name: {{ include "template.volume.name" .context }}-{{ .name }}
  readOnly: true
  mountPath: {{ .mount }}
{{- end -}}

{{/* #################### */}}
