# cactus-public-api

Helm chart for deploying cactus-public-api (CPA / Gotu edge).

**Source of truth for chart edits:** this directory (`matterless/helm-charts` `charts/cactus-public-api`).
Published to `https://charts.lookingglassprotocol.com`. Matterless env overlays live in
`matterless/cactus-public-api` `helm/` (wrapper chart depending on this package).

## Installing

```console
helm repo add matterless https://charts.lookingglassprotocol.com
helm repo update
helm dependency update
helm install cactus-public-api matterless/cactus-public-api -f my-values.yaml
```

## Required secrets (not in values)

Provide via Kubernetes secret / `envFrom` (names only — never commit values):

- `AUKI_APP_KEY` / `AUKI_APP_SECRET` (DDS)
- Per-zorg M2M: `CLIENT_ID_<zitadel-org-id>` / `CLIENT_SECRET_<zitadel-org-id>`

## Key env defaults

| Key | Default |
|-----|---------|
| `AUKI_API_URL` | `https://api.auki.network` |
| `AUKI_DDS_URL` | `https://dds.auki.network` |
| `AUTH_URL` | `https://auth.auki.network` |
| `CONFIG_URL` | `https://config.lookingglassprotocol.com` |
| `PUBLIC_DOMAINS` | `{}` JSON `{ "zorg_id": ["domain-id", ...] }` (empty → no domains) |
| `PROJECT_IDS` | `342480985197117780,342481000464384340` (prod/default; override per env) |

Override image repository/tag and secrets for Auki or self-hosted deploys.

## Verify locally

```console
helm dependency update ./charts/cactus-public-api
helm template test ./charts/cactus-public-api | grep -E 'CONFIG_URL|AUTH_URL|PUBLIC_DOMAINS|PROJECT_IDS|AUKI_'
```
