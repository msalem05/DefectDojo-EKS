#!/usr/bin/env bash
set -euo pipefail

IMAGE_URI="${1:?Usage: $0 <image-uri>}"
VALUES_FILE="k8s/helm/values.yaml"

if [[ ! -f "$VALUES_FILE" ]]; then
  echo "ERROR: $VALUES_FILE not found"
  exit 1
fi

IMAGE_REPOSITORY="${IMAGE_URI%:*}"
IMAGE_TAG="${IMAGE_URI##*:}"

export IMAGE_REPOSITORY IMAGE_TAG

echo "Updating Helm image values..."

yq -i '
  .image.repository = strenv(IMAGE_REPOSITORY) |
  .image.tag = strenv(IMAGE_TAG)
' "$VALUES_FILE"

echo "Updated image repository: $IMAGE_REPOSITORY"
echo "Updated image tag: $IMAGE_TAG"