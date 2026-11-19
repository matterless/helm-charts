#!/usr/bin/env bash
set -euo pipefail

chart_dir="$(cd "$(dirname "$0")/.." && pwd)"
registry="992382468184.dkr.ecr.eu-central-1.amazonaws.com"
username="AWS"
password="$(aws ecr get-login-password)"

kubectl create secret \
  docker-registry \
  matterless-common-ecr-credentials \
  --docker-server="$registry" \
  --docker-username="$username" \
  --docker-password="$password" \
  --dry-run=client \
  -o yaml > "$chart_dir/templates/ecr-testing-secret.yaml"

: "${APP_KEY:?APP_KEY is required for CPA chart-testing}"
: "${APP_SECRET:?APP_SECRET is required for CPA chart-testing}"

kubectl create secret generic cactus-public-api \
  --from-literal=AUKI_APP_KEY="$APP_KEY" \
  --from-literal=AUKI_APP_SECRET="$APP_SECRET" \
  --dry-run=client \
  -o yaml > "$chart_dir/templates/cpa-testing-secret.yaml"

yq -i '."k8s-service".imagePullSecrets[0].name = "matterless-common-ecr-credentials"' \
  "$chart_dir/values.yaml"
