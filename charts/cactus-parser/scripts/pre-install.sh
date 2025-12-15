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
yq -i '.image.repository = "992382468184.dkr.ecr.eu-central-1.amazonaws.com/cactus-pidb"' "$(dirname "$0")/../values.yaml"
yq -i '.image.tag = "feature-integration-api-cleanup"' "$(dirname "$0")/../values.yaml"
yq -i '.secrets."cactus-parser".as = "environment"' "$(dirname "$0")/../values.yaml"
yq -i '.secrets."cactus-parser".items[0].key = "POSTGRES_PASSWORD"' "$(dirname "$0")/../values.yaml"
yq -i '.secrets."cactus-parser".items[0].envVarName = "POSTGRES_PASSWORD"' "$(dirname "$0")/../values.yaml"
