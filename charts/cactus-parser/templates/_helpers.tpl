{{/*
Expand the name of the chart.
*/}}
{{- define "cactus-parser.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cactus-parser.fullname" -}}
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
{{- define "cactus-parser.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cactus-parser.labels" -}}
helm.sh/chart: {{ include "cactus-parser.chart" . }}
{{ include "cactus-parser.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cactus-parser.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cactus-parser.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cactus-parser.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cactus-parser.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Set GOMEMLIMIT to 90% of the memory limit
https://www.reddit.com/r/golang/comments/1cm1pom/running_out_of_memory_in_a_1gb_vm_on_flyio_when/
https://medium.com/mop-developers/when-kubernetes-and-go-dont-work-well-together-54533bb6466a
*/}}
{{- define "goMemLimitEnv" -}}
{{- $memory := .Values.resources.limits.memory -}}
{{- if $memory -}}
- name: GOMEMLIMIT
  {{- $value := regexFind "^\\d*\\.?\\d+" $memory | float64 -}}
  {{- $unit := regexFind "[A-Za-z]+" $memory -}}
  {{- $valueMi := 0.0 -}}
  {{- if eq $unit "Gi" -}}
    {{- $valueMi = mulf $value 1024 -}}
  {{- else if eq $unit "Mi" -}}
    {{- $valueMi = $value -}}
  {{- end -}}
  {{- $percentageValue := int (mulf $valueMi 0.7) }}
  value: {{ printf "%dMiB" $percentageValue -}}
{{- end -}}
{{- end -}}

