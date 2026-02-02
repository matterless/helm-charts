# cactus-backend

Helm chart for deploying the cactus-backend on Kubernetes.

## Introduction

This chart bootstraps cactus-backend on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `cactus-backend`:

```console
helm repo add matterless https://charts.lookingglassprotocol.com
helm repo update
helm install cactus-backend matterless/cactus-backend
```

## Uninstalling the Chart

To uninstall/delete the `cactus-backend` deployment:

```console
helm uninstall cactus-backend
```

## Configuration

Refer to the [values.yaml](./values.yaml) file for a comprehensive list of configurable parameters and their default values.

You can specify parameters with `--set key=value` or by providing a custom YAML file:

```console
helm install cactus-backend matterless/cactus-backend -f my-values.yaml
```

Please go through the whole `values.yaml` file and follow the instructions in the comments to configure the application
to suit your environment and needs. Some of the credentials like the app key and app secret can be obtained from the
[console](https://console.auki.network/) and for configurations like the auth JWT profile, reach out to Auki for help.

It's important to configure the blob storage type correctly so persistent data like shelf snapshots can be stored.
In order to run more than one replica (pod), S3 storage is preferred, unless your persistent volume claim (PVC) can be
shared across replicas.

For more information on the S3 storage configuration, see
[AWS SDK Configuration](https://docs.aws.amazon.com/sdk-for-go/v2/developer-guide/configure-gosdk.html) and
[S3 Reference Guide](https://docs.aws.amazon.com/general/latest/gr/s3.html).

For more information on how to use JuiceFS to act as a caching layer and also bridge to Azure Blob Storage, see this
[guide](https://github.com/aukilabs/domain-server/blob/main/docs/deployment-azure.md) for the Auki Domain Server
which has a very similar configuration structure in its Helm chart as this Helm chart.

## Upgrading

To upgrade your deployment:

```console
helm upgrade cactus-backend matterless/cactus-backend
```

**Important:**
Before upgrading from chart version please review the following steps:

1. **Review the [values.yaml](./values.yaml) file** for any new, deprecated, or changed configuration options.
2. **Custom Values:** If you use a custom values file, compare it to the new `values.yaml` and update your overrides as needed.
3. **Breaking Changes:** Watch for any breaking changes to deployment templates, environment variables, or persistent storage. Consider using `helm diff` to preview changes:
   ```console
   helm plugin install https://github.com/databus23/helm-diff
   helm diff upgrade cactus-backend matterless/cactus-backend -f my-values.yaml
   ```
4. **Backup:** If your deployment uses persistent data, ensure you have backups.
5. **Test:** Consider upgrading in a staging environment before production.

### Upgrading to 0.5.0

Version 0.5.0 introduces significant changes to the feature set of the Cactus Backend:

* The backend is now using Rust + PostgreSQL instead of Pocketbase (with a bundled
  SQLite database).
* See the [migration guide](./pocketbase-migration.md) for details on how to migrate your data.
* PostgreSQL and Redis are now required dependencies. You can either run these services
  separately or use the included subcharts.
* Multiple replicas are now supported. Set `replicaCount` to more than 1 to enable.
  If you run more than one replica, you must set `envVars.BLOB_STORAGE_TYPE` to
  something other than `local` (e.g. `s3`) and configure the storage endpoint, bucket
  name etc. You probably also want to set `kind` to `Deployment` instead of the default
  `StatefulSet`.

#### Breaking changes

* The `client` value has been removed. Instead set the `image.repository` to the image
  that contains your applicable product and sales data integration code.
* The backend is more efficient than before, but the default resource requests and limits have
  been commented out as they are only provided as a reference. You may want to set these values
  based on your workload. You can also enable autoscaling.
* `APP_KEY` and `APP_SECRET` environment variables are required, you can obtain them
  from your app section of the [Auki console](https://console.auki.network). `APP_KEY`
  goes into `envVars.APP_KEY` and `APP_SECRET` into `secretData.APP_SECRET` or into
  the `APP_SECRET` key of an existing secret (configured through `existingSecretName`)
  when `useExistingSecret` is `true`.
* `AUTH_JWT_PROFILE` is another secret that needs to be obtained from Auki staff to be
  able to log in to the backend.
* `TOKEN_ENCRYPTION_KEY` is another secret which is the key for the Firebase token
  encryption. It should be a random string of 32 characters. See the comments in
  `values.yaml`.

### Upgrading to 0.5.8

#### Features

* The Cactus Parser is now deployed as an independent service alongside the Cactus Backend. Be sure to set the `PARSER_URL` variable to the URL of your deployed Cactus Parser instance.
* You can now manage multiple configuration files using a ConfigMap. To enable this, set `configFiles.enabled: true` in your values file. This allows you to mount custom configuration files directly via ConfigMap.
* Semantic events can be sent to an external webhook by setting `EVENTS_ENABLED: true` and providing your webhook endpoint via `EVENTS_URL`, webhook auth token via `EVENTS_AUTH_TOKEN` in Cactus Backend's environment variables or secrets. By default, semantic events are processed and sent every 5 minutes. If you need to adjust this frequency, update `CRONJOBS_PROCESS_EVENTS_SCHEDULE` in the values or environment variables.
* If your deployment needs to map external to internal domain IDs, set `DOMAIN_EXTERNAL_ID_MAPPINGS_FILE` to the filename or full path of your mapping file.

### Upgrading to 0.5.9

#### Features

* OpenTelemetry support is now available. To enable telemetry collection, set the `OTEL_COLLECTOR_GRPC_ENDPOINT` environment variable to the gRPC endpoint of your OpenTelemetry Collector. This should be configured for both the Cactus Backend and Cactus Parser.

  * To monitor these services with Azure Application Insights, refer to the [Azure Monitor Exporter](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter/azuremonitorexporter).
  * For Prometheus integration, enable `podMonitor` and the `prometheus` port, and see the [Spanmetrics Connector for Prometheus](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/connector/spanmetricsconnector).
  * For additional configuration details, consult the [OpenTelemetry Collector documentation](https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-collector).

### Upgrading to 0.5.11

#### Features

* OpenTelemetry can be toggled on or off as required. To enable it for both the Cactus Backend and Cactus Parser, set `cactus-backend.envVars.OTEL_ENABLED` and `cactus-backend.cactus-parser.envVars.OTEL_ENABLED` to `true`.

## Chart Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration values
- `templates/` - Kubernetes resource templates
