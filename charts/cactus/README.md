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

Please go through the whole `values.yaml` file and follow the instructions in the comments to configure the application
to suit your environment and needs. Credentials like the Amplitude API key and Joystick API key can be
obtained from the [console](https://console.auki.network/) and for configurations like the Zitadel client ID,
reach out to Auki for help.

## Upgrading

To upgrade your deployment:

```console
helm upgrade cactus matterless/cactus
```

**Important:**  
Before upgrading, please review the following steps:

1. **Review the [values.yaml](./values.yaml) file** for any new, deprecated, or changed configuration options.
2. **Custom Values:** If you use a custom values file, compare it to the new `values.yaml` and update your overrides as needed.
3. **Breaking Changes:** Watch for any breaking changes to deployment templates, environment variables, or persistent storage. Consider using `helm diff` to preview changes:
   ```console
   helm plugin install https://github.com/databus23/helm-diff
   helm diff upgrade cactus matterless/cactus -f my-values.yaml
   ```
4. **Backup:** If your deployment uses persistent data, ensure you have backups.
5. **Test:** Consider upgrading in a staging environment before production.

### Upgrading to 0.0.4

**Breaking change — app key and secret removed from values.**

`EXPO_PUBLIC_AUKI_APP_KEY`, `EXPO_PUBLIC_AUKI_APP_SECRET`, `AUKI_APP_KEY`, and `AUKI_APP_SECRET` have been removed from the chart. They must not be embedded in the client-facing helm chart.

If you have been overriding these values, they are no longer recognized and should be removed from your custom values file.

The `EXPO_PUBLIC_AUKI_API_PROJECT_ID` (value: `342480985197117780`) and `AUKI_API_PROJECT_ID` should be used instead to identify the API project at runtime. These are already set as defaults in `values.yaml` and do not need to be provided by users.

## Chart Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration values
- `templates/` - Kubernetes resource templates
