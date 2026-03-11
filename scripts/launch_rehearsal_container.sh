#!/usr/bin/env bash

set -euo pipefail

HOST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE="${D796_IMAGE:-ubuntu:22.04}"

if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed or not in PATH."
  exit 1
fi

echo "Starting rehearsal container from image: $IMAGE"
echo "Mounting project: $HOST_ROOT -> /workspace"

docker run --rm -it \
  --name d796-rehearsal \
  -v "$HOST_ROOT:/workspace" \
  -w /workspace/scripts \
  "$IMAGE" \
  bash -lc '
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y sudo iputils-ping dnsutils

echo
echo "Container ready. Current directory: /workspace/scripts"
echo "Run: ./verify_required_for_video.sh"
echo

cd /workspace/scripts
exec bash
'
