# cassandra

[Apache Cassandra](https://cassandra.apache.org) is a free and open-source distributed database management system designed to handle large amounts of data across many commodity servers or datacenters.

## TL;DR

```console
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install my-release bitnami/cassandra
```

## Introduction

This chart install an [Apache Cassandra](https://github.com/apache/cassandra) deployment on a [Kubernetes](http://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.


## Prerequisites

- Kubernetes 1.16+
- Helm 3.1.0
- PV provisioner support in the underlying infrastructure

## Installing Helm3
# Linux:
$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh

# From Homebrew (macOS)
$ brew install helm

$ helm version
version.BuildInfo{Version:"v3.6.3", GitCommit:"d506314abfb5d21419df8c7e7e68012379db2354", GitTreeState:"dirty", GoVersion:"go1.16.5"}

## Test the Chart
helm lint charts/cassandra/
helm template charts/cassandra/ -f -f override/helm_cassandra.yaml

## Installing the Chart

To install the chart with the release name `cassandra`:

```console
$ 
$ helm install cassandra --namespace=cassandra charts/cassandra/ -f override/helm_cassandra.yaml --debug

```

These commands deploy one node with Apache Cassandra on the Kubernetes cluster in the default configuration.

## Listing helm chart
helm list --namespace=cassandra

## Uninstalling the Chart

To uninstall/delete the `cassandra` release:

```console
$ helm uninstall cassandra --namespace=cassandra
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `replicaCount`    | Replication count | `1` |
| `updateStrategy`  | updateStrategy updateStrategy for Cassandra statefulset | `RollingUpdate` |
| `image.repository`    | Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | StorageClass for Persistent Volume(s)    | `""`  |


### Cassandra parameters

| Name                        | Description                                                                             | Value           |
| ------------------------    | --------------------------------------------------------------------------------------- | --------------- |
| `replicaCount`              |  Replication count                                                                      | `1`             |
| `updateStrategy`            | updateStrategy updateStrategy for Cassandra statefulset                                 | `RollingUpdate` |
| `podManagementPolicy`       | StatefulSet pod management policy                                                       | `OrderedReady`  |
| `image.repository`          | Docker image registry                                                                   | `cassandra`     |
| `image.tag`                 | Cassandra image tag                                                                     | `4`             |
| `image.pullPolicy`          | image pull policy                                                                       | `IfNotPresent`  |
| `imagePullSecrets`          | Cassandra image pull secrets                                                            | `[]`            |
| `nameOverride`              | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`          | String to fully override common.names.fullname                                          | `""`            |
| `clusterDomain`             | Kubernetes cluster domain name                                                          | `cluster.local` |
| `podAnnotations`            | Additional pod annotations                                                              | `{}`            |
| `dbUser.user`               | Cassandra admin user                                                                    | `cassandra`     |
| `dbUser.forcePassword`      | Force the user to provide a non                                                         | `false`         |
| `dbUser.password`           | Password for `dbUser.user`. Randomly generated if empty                                 | `""`            |
| `dbUser.existingSecret`     | Use an existing secret object for `dbUser.user` password(will ignore `dbUser.password`) | `""`            |
| `cluster.name`              | Cassandra cluster name                                                                  | `cassandra`     |
| `cluster.seedCount`         | Number of seed nodes                                                                    | `1`             |
| `cluster.numTokens`         | Number of tokens for each node                                                          | `256`           |
| `cluster.datacenter`        | Datacenter name                                                                         | `dc1`           |
| `cluster.rack`              | Rack name                                                                               | `rack1`         |
| `jvm.extraOpts`             | Set the value for Java Virtual Machine extra options                                    | `""`            |
| `jvm.maxHeapSize`           | Set Java Virtual Machine maximum heap size (MAX_HEAP_SIZE)                              | `""`            |
| `jvm.newHeapSize`           | Set Java Virtual Machine new heap size (HEAP_NEWSIZE).                                  | `""`            |
| `podAffinityPreset`         | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`     | `""`            |
| `podAntiAffinityPreset`     | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`| `soft`          |
| `nodeAffinityPreset.type`   | Node affinity preset type.Ignored if `affinity` is set. Allowed values: `soft` or `hard`| `""`            |
| `nodeAffinityPreset.key`    | Node label key to match. Ignored if `affinity` is set                                   | `""`            |
| `nodeAffinityPreset.values` | Node label values to match. Ignored if `affinity` is set                                | `[]`            |
| `affinity`                  | Affinity for pod assignment                                                             | `{}`            |
| `nodeSelector`              | Node labels for pod assignment                                                          | `{}`            |
| `tolerations`               | Tolerations for pod assignment                                                          | `[]`            |
| `podSecurityContext.enabled`| Enabled Cassandra pods' Security Context                                                | `true`          |
| `podSecurityContext.fsGroup`| Set Cassandra pod's Security Context fsGroup                                            | `1001`          |
| `resources.limits`          | The resources limits for Cassandra containers                                           | `{}`            |
| `resources.requests`        | The requested resources for Cassandra containers                                        | `{}`            |
| `livenessProbe.enabled`     | Enable livenessProbe                                                                    | `true`          |
| `livenessProbe.initialDelaySeconds`  | Initial delay seconds for livenessProbe                                          | `60`            |
| `livenessProbe.periodSeconds`        | Period seconds for livenessProbe                                                 | `30`            |
| `livenessProbe.timeoutSeconds`       | Timeout seconds for livenessProbe                                                | `5`             |
| `livenessProbe.failureThreshold`     | Failure threshold for livenessProbe                                              | `5`             |
| `livenessProbe.successThreshold`     | Success threshold for livenessProbe                                              | `1`             |
| `readinessProbe.enabled`             | Enable readinessProbe                                                            | `true`          |
| `readinessProbe.initialDelaySeconds` | Initial delay seconds for readinessProbe                                         | `60`            |
| `readinessProbe.periodSeconds`       | Period seconds for readinessProbe                                                | `10`            |
| `readinessProbe.timeoutSeconds`      | Timeout seconds for readinessProbe                                               | `5`             |
| `readinessProbe.failureThreshold`    | Failure threshold for readinessProbe                                             | `5`             |
| `readinessProbe.successThreshold`    | Success threshold for readinessProbe                                             | `1`             |
| `pdb.create`                         | Enable/disable a Pod Disruption Budget creation                                  | `false`         |
| `pdb.minAvailable`                   | Mininimum number of pods that must still be available after the eviction         | `1`             |
| `pdb.maxUnavailable`                 | Max number of pods that can be unavailable after the eviction                    | `""`            |
| `containerPorts.intra`               | Intra Port on the Host and Container                                             | `7000`          |
| `containerPorts.tls`                 | TLS Port on the Host and Container                                               | `7001`          |
| `containerPorts.jmx`                 | JMX Port on the Host and Container                                               | `7199`          |
| `containerPorts.cql`                 | CQL Port on the Host and Container                                               | `9042`          |


### RBAC parameters

| Name                         | Description                                                | Value  |
| ---------------------------- | ---------------------------------------------------------- | ------ |
| `serviceAccount.create`      | Enable the creation of a ServiceAccount for Cassandra pods | `true` |
| `serviceAccount.name`        | The name of the ServiceAccount to use.                     | `""`   |
| `serviceAccount.annotations` | Annotations for Cassandra Service Account                  | `{}`   |


### Traffic Exposure Parameters

| Name                          | Description                                               | Value       |
| ----------------------------- | --------------------------------------------------------- | ----------- |
| `service.type`                | Cassandra service type                                    | `ClusterIP` |
| `service.port`                | Cassandra service CQL Port                                | `9042`      |
| `service.metricsPort`         | Cassandra service metrics port                            | `8080`      |
| `service.nodePorts.cql`       | Node port for CQL                                         | `""`        |
| `service.nodePorts.metrics`   | Node port for metrics                                     | `""`        |
| `service.loadBalancerIP`      | LoadBalancerIP if service type is `LoadBalancer`          | `""`        |
| `service.annotations`         | Provide any additional annotations which may be required. | `{}`        |
| `networkPolicy.enabled`       | Specifies whether a NetworkPolicy should be created       | `false`     |
| `networkPolicy.allowExternal` | Don't require client label for connections                | `true`      |


### Persistence parameters

| Name                             | Description                                                                                        | Value                |
| -------------------------------- | -------------------------------------------------------------------------------------------------- | -------------------- |
| `persistence.enabled`            | Enable Cassandra data persistence using PVC, use a Persistent Volume Claim, If false, use emptyDir | `true`               |
| `persistence.storageClass`       | PVC Storage Class for Cassandra data volume                                                        | `""`                 |
| `persistence.commitStorageClass` | PVC Storage Class for Cassandra Commit Log volume                                                  | `""`                 |
| `persistence.annotations`        | Persistent Volume Claim annotations                                                                | `{}`                 |
| `persistence.accessModes`        | Persistent Volume Access Mode                                                                      | `[]`                 |
| `persistence.size`               | PVC Storage Request for Cassandra data volume                                                      | `8Gi`                |
| `persistence.mountPath`          | The path the data volume will be mounted at                                                        | `/var/lib/cassandra/data` |