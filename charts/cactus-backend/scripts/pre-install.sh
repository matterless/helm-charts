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

kubectl create secret cactus-backend-test \
  --from-literal=AUTH_JWT_PROFILE=$AUTH_JWT_PROFILE \
  --from-literal=APP_SECRET=test \
  --from-literal=TOKEN_ENCRYPTION_KEY=test \
  --from-literal=REDIS_PASSWORD=cactus-backend \
  --from-literal=POSTGRES_PASSWORD=cactus-backend \
  --dry-run=client -o yaml | kubectl apply -f -

yq -i '.imagePullSecrets[0].name = "matterless-common-ecr-credentials"' "$(dirname "$0")/../values.yaml"
