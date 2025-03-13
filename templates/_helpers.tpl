{{/*
Expand the name of the chart.
*/}}
{{- define "common-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "common-service.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "common-service.labels" -}}
helm.sh/chart: {{ include "common-service.chart" . }}
{{ include "common-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "common-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "common-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "common-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Generate vault-related pod annotations based on vault_path values.
*/}}
{{- define "common-service.vaultAnnotations" -}}
vault.hashicorp.com/agent-inject: 'true'
vault.hashicorp.com/role: "{{ .Values.vault_settings.role }}" 
vault.hashicorp.com/agent-inject-secret-common: "{{ .Values.vault_settings.common_secrets }}" 
vault.hashicorp.com/agent-inject-template-common: |
  {{`{{- with secret "`}}{{ .Values.vault_settings.common_secrets }}{{`" -}}`}}
    {{`{{- range $key, $value := .Data.data }}`}}
      {{`export {{ $key }}="{{ $value }}"`}}
    {{`{{- end }}`}}
  {{`{{- end }}`}}
vault.hashicorp.com/agent-inject-secret-config: "{{ .Values.vault_settings.service_secrets }}"
vault.hashicorp.com/agent-inject-template-config: |
  {{`{{- with secret "`}}{{ .Values.vault_settings.service_secrets }}{{`" -}}`}}
    {{`{{- range $key, $value := .Data.data }}`}}
      {{`export {{ $key }}="{{ $value }}"`}}
    {{`{{- end }}`}}
  {{`{{- end }}`}}
vault.hashicorp.com/agent-limits-cpu: 32m
vault.hashicorp.com/agent-requests-cpu: 16m
{{- end }}
