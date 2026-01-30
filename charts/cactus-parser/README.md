# cactus-parser

Helm chart for deploying the cactus-parser on Kubernetes.

## Introduction

This chart bootstraps cactus-parser on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `cactus-parser`:

```console
helm repo add matterless https://charts.lookingglassprotocol.com
helm repo update
helm install cactus-parser matterless/cactus-parser
```

## Uninstalling the Chart

To uninstall/delete the `cactus-parser` deployment:

```console
helm uninstall cactus-parser
```

## Configuration

The default parser is PIDB which requires PostgreSQL but other parsers can also be used as instructed by Auki Labs.

Refer to the [values.yaml](./values.yaml) file for a comprehensive list of configurable parameters and their default values.
If you're using a parser other than the default one, some environment variable may be irrelevant and can be deleted,
such as those for PostgreSQL.

You can specify parameters with `--set key=value` or by providing a custom YAML file:

```console
helm install cactus-parser matterless/cactus-parser -f my-values.yaml
```

## Upgrading

To upgrade your deployment:

```console
helm upgrade cactus-parser matterless/cactus-parser
```

**Important:**  
Before upgrading from chart version please review the following steps:

1. **Review the [values.yaml](./values.yaml) file** for any new, deprecated, or changed configuration options.
2. **Custom Values:** If you use a custom values file, compare it to the new `values.yaml` and update your overrides as needed.
3. **Breaking Changes:** Watch for any breaking changes to deployment templates, environment variables, or persistent storage. Consider using `helm diff` to preview changes:
   ```console
   helm plugin install https://github.com/databus23/helm-diff
   helm diff upgrade cactus-parser matterless/cactus-parser -f my-values.yaml
   ```
4. **Backup:** If your deployment uses persistent data, ensure you have backups.
5. **Test:** Consider upgrading in a staging environment before production.

## Chart Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration values
- `templates/` - Kubernetes resource templates

