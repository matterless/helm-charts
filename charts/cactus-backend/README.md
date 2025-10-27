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

## Upgrading

To upgrade your deployment:

```console
helm upgrade cactus-backend matterless/cactus-backend
```

**Important:**  
Before upgrading from chart version please review the following steps:

1. **Review the [values.yaml](./values.yaml) and [CHANGELOG](./CHANGELOG.md) files** for any new, deprecated, or changed configuration options.
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
  SQLite database)
* See the [migration guide](./pocketbase-migration.md) for details on how to migrate your data.
* PostgreSQL and Redis are now required dependencies. You can either run these services
  separately or use the included subcharts.
* Multiple replicas are now supported. Set `replicaCount` to more than 1 to enable.
  If you run more than one replica, you must set `envVars.BLOB_STORAGE_TYPE` to
  something other than `local` (e.g. `s3`) and configure the storage endpoint, bucket
  name etc.

## Chart Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration values
- `templates/` - Kubernetes resource templates
