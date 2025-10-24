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

# Create cactus-backend-test secret using cat to handle special characters
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: cactus-backend-test
type: Opaque
data:
  AUTH_JWT_PROFILE: $(echo -n "$AUTH_JWT_PROFILE" | base64 | tr -d '\n')
  APP_SECRET: $(echo -n "test" | base64 | tr -d '\n')
  TOKEN_ENCRYPTION_KEY: $(echo -n "test" | base64 | tr -d '\n')
  REDIS_PASSWORD: $(echo -n "cactus-backend" | base64 | tr -d '\n')
  POSTGRES_PASSWORD: $(echo -n "cactus-backend" | base64 | tr -d '\n')
EOF

yq -i '.imagePullSecrets[0].name = "matterless-common-ecr-credentials"' "$(dirname "$0")/../values.yaml"
