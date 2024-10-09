#!/usr/bin/env bash

registry="992382468184.dkr.ecr.eu-central-1.amazonaws.com"
username="AWS"
password="$(aws ecr get-login-password | docker login --username "$username" --password-stdin "$registry")"

kubectl create secret \
  docker-registry \
  matterless-common-ecr-credentials \
  --docker-server="$registry" \
  --docker-username="$username" \
  --docker-password="$password"

yq -i '.imagePullSecrets[0].name = "matterless-common-ecr-credentials"' "$(dirname "$0")/../values.yaml"
