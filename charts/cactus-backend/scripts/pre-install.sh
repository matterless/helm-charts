#!/usr/bin/env bash

: "${DOCKER_PASSWORD?Need to set DOCKER_PASSWORD}"

kubectl create secret \
  docker-registry \
  matterless-common-ecr-credentials \
  --docker-server="992382468184.dkr.ecr.eu-central-1.amazonaws.com" \
  --docker-username="AWS" \
  --docker-password="$DOCKER_PASSWORD"

yq -i '.imagePullSecrets[0].name = "matterless-common-ecr-credentials"' "$(dirname "$0")/../values.yaml"
