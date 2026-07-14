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
to suit your environment and needs. Get credentials like the Amplitude API key and Joystick API key from Auki.

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

### Upgrading to 0.0.6

**New environment variable: `EXPO_PUBLIC_RETAIL_OPS_CONFIG_URL`.**

The retail-ops client configuration URL is now configurable instead of being hardcoded to the
production URL in the app. The chart defaults to the production config
(`https://config.lookingglassprotocol.com/retail-ops.json`); override it in `envVars` to point a
deployment at a different retail-ops config. The variable is also registered in
`entrypointEnvVars` so it gets substituted into the JS bundles at container startup.

No action is required for existing deployments: older Cactus versions ignore the variable, and
versions that support it fall back to the production URL whenever the value is unset or not
substituted (an error is logged in the browser console). If you override the `entrypointEnvVars`
list in a custom values file **and** want a non-default config URL, add `RETAIL_OPS_CONFIG_URL` to
your list — otherwise your custom URL is never substituted into the JS bundles and the app quietly
stays on the production fallback.

### Upgrading to 0.0.5

**app key and secret removed from values.**

`EXPO_PUBLIC_AUKI_APP_KEY`, `EXPO_PUBLIC_AUKI_APP_SECRET` are no longer needed from Cactus v0.11.3.

If you have been overriding these values, they are no longer recognized and should be removed from your custom values file.

## Chart Structure

- `Chart.yaml` - Chart metadata
- `values.yaml` - Default configuration values
- `templates/` - Kubernetes resource templates
