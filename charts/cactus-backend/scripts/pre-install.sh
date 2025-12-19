#!/usr/bin/env bash

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
  -o yaml > "$(dirname "$0")/../templates/ecr-testing-secret.yaml"

yq -i '.imagePullSecrets[0].name = "matterless-common-ecr-credentials"' "$(dirname "$0")/../values.yaml"
yq -i '.secretData.AUTH_JWT_PROFILE = strenv(AUTH_JWT_PROFILE)' "$(dirname "$0")/../values.yaml"
yq -i '.secretData.APP_SECRET = strenv(APP_SECRET)' "$(dirname "$0")/../values.yaml"
yq -i '.envVars.APP_KEY = strenv(APP_KEY)' "$(dirname "$0")/../values.yaml"
yq -i '.image.tag = "feature-integration-api-cleanup"' "$(dirname "$0")/../values.yaml"
yq -i '.image.repository = "992382468184.dkr.ecr.eu-central-1.amazonaws.com/internal-cactus-backend"' "$(dirname "$0")/../values.yaml"
yq -i '."cactus-parser".image.tag = "feature-integration-api-cleanup"' "$(dirname "$0")/../values.yaml"
yq -i '."cactus-parser".enabled = true' "$(dirname "$0")/../values.yaml"
yq -i '."cactus-parser".imagePullSecrets[0].name = "matterless-common-ecr-credentials"' "$(dirname "$0")/../values.yaml"
