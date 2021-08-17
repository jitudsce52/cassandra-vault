{{/*
Expand the name of the chart.
*/}}
{{- define "cassandra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cassandra.fullname" -}}
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
{{- define "cassandra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cassandra.labels" -}}
helm.sh/chart: {{ include "cassandra.chart" . }}
{{ include "cassandra.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cassandra.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cassandra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Labels to use on matchLabels
*/}}
{{- define "cassandra.matchLabels" -}}
{{ include "cassandra.selectorLabels" .}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "cassandra.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cassandra.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Return a soft nodeAffinity definition 
{{ include "cassandra.affinities.nodes.soft" (dict "key" "BOOT" "values" (list "ONE" "TWO")) -}}
*/}}
{{- define "cassandra.affinities.nodes.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
    weight: 1
{{- end -}}

{{/*
Return a hard nodeAffinity definition
{{ include "cassandra.affinities.nodes.hard" (dict "key" "BOOT" "values" (list "ONE" "TWO")) -}}
*/}}
{{- define "cassandra.affinities.nodes.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
    - matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
{{- end -}}

{{/*
Return a nodeAffinity definition
{{ include "cassandra.affinities.nodes" (dict "type" "soft" "key" "BOOT" "values" (list "ONE" "TWO")) -}}
*/}}
{{- define "cassandra.affinities.nodes" -}}
  {{- if eq .type "soft" }}
    {{- include "cassandra.affinities.nodes.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "cassandra.affinities.nodes.hard" . -}}
  {{- end -}}
{{- end -}}

{{/*
Return a soft podAffinity/podAntiAffinity definition
{{ include "cassandra.affinities.pods.soft" (dict "component" "BOOT" "extraMatchLabels" .Values.extraMatchLabels "context" $) -}}
*/}}
{{- define "cassandra.affinities.pods.soft" -}}
{{- $component := default "" .component -}}
{{- $extraMatchLabels := default (dict) .extraMatchLabels -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "cassandra.matchLabels" .context) | nindent 10 }}
          {{- if not (empty $component) }}
          {{ printf "app.kubernetes.io/component: %s" $component }}
          {{- end }}
          {{- range $key, $value := $extraMatchLabels }}
          {{ $key }}: {{ $value | quote }}
          {{- end }}
      namespaces:
        - {{ .context.Release.Namespace | quote }}
      topologyKey: kubernetes.io/hostname
    weight: 1
{{- end -}}

{{/*
Return a hard podAffinity/podAntiAffinity definition
{{ include "cassandra.affinities.pods.hard" (dict "component" "BOOT" "extraMatchLabels" .Values.extraMatchLabels "context" $) -}}
*/}}
{{- define "cassandra.affinities.pods.hard" -}}
{{- $component := default "" .component -}}
{{- $extraMatchLabels := default (dict) .extraMatchLabels -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "cassandra.matchLabels" .context) | nindent 8 }}
        {{- if not (empty $component) }}
        {{ printf "app.kubernetes.io/component: %s" $component }}
        {{- end }}
        {{- range $key, $value := $extraMatchLabels }}
        {{ $key }}: {{ $value | quote }}
        {{- end }}
    namespaces:
      - {{ .context.Release.Namespace | quote }}
    topologyKey: kubernetes.io/hostname
{{- end -}}

{{/*
Return a podAffinity/podAntiAffinity definition
{{ include "cassandra.affinities.pods" (dict "type" "soft" "key" "BOOT" "values" (list "ONE" "TWO")) -}}
*/}}
{{- define "cassandra.affinities.pods" -}}
  {{- if eq .type "soft" }}
    {{- include "cassandra.affinities.pods.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "cassandra.affinities.pods.hard" . -}}
  {{- end -}}
{{- end -}}

{{/*
Return the list of Cassandra seed nodes
*/}}
{{- define "cassandra.seeds" -}}
{{- $seeds := list }}
{{- $fullname := include "cassandra.fullname" .  }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $seedCount := .Values.cluster.seedCount | int }}
{{- range $e, $i := until $seedCount }}
{{- $seeds = append $seeds (printf "%s-%d.%s-headless.%s.svc.%s." $fullname $i $fullname $releaseNamespace $clusterDomain) }}
{{- end }}
{{- range .Values.cluster.extraSeeds }}
{{- $seeds = append $seeds . }}
{{- end }}
{{- join "," $seeds }}
{{- end -}}