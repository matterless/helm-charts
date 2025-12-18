# cactus

Helm chart for deploying the Cactus web client on Kubernetes.

## Introduction

This chart bootstraps Cactus Web on a Kubernetes cluster using the [Helm](https://helm.sh/) package manager.

Cactus web is an interface for the Cactus backend which you can also find a chart for in this repo.

## Prerequisites

- Kubernetes 1.23+
- Helm 3.0+

## Installing the Chart

To install the chart with the release name `cactus`:

```console
helm repo add matterless https://charts.lookingglassprotocol.com
helm repo update
helm install cactus matterless/cactus
```

## Uninstalling the Chart

To uninstall/delete the `cactus` deployment:

```console
helm uninstall cactus
```

## Configuration

Refer to the [values.yaml](./values.yaml) file for a comprehensive list of configurable parameters and their default values.

You can specify parameters with `--set key=value` or by providing a custom YAML file:

```console
helm install cactus matterless/cactus -f my-values.yaml
```

Please go through the whole `values.yaml` and follow the instructions in the comments to configure the application to
suit your environment and needs. Some of the credentials like the app key and app secret can be
obtained from the [console](https://console.auki.network/) and for configurations like the Amplitude API key,
Joystick API key and Zitadel client ID, reach out to Auki for help.

## Upgrading

To upgrade your deployment:

```console
helm upgrade cactus matterless/cactus
```

**Important:**  
Before upgrading from chart version please review the following steps:

1. **Review the [values.yaml](./values.yaml) file** for any new, deprecated, or changed configuration options.
2. **Custom Values:** If you use a custom values file, compare it to the new `values.yaml` and update your overrides as needed.
3. **Breaking Changes:** Watch for any breaking changes to deployment templates, environment variables, or persistent storage. Consider using `helm diff` to preview changes:
   ```console
   helm plugin install https://github.com/databus23/helm-diff
   helm diff upgrade cactus matterless/cactus -f my-values.yaml
   ```
4. **Backup:** If your deployment uses persistent data, ensure you have backups.
5. **Test:** Consider upgrading in a staging environment before production.

### Upgrading to x.x.x

We will update this section if there are any specific things to watch out for when upgrading to a certain version of
the chart, for example if there have been breaking changes or other major architectural enhancements.

## Chart Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration values
- `templates/` - Kubernetes resource templates
