#!/usr/bin/env bash

set -euo pipefail

if ping -c 4 8.8.8.8 >/dev/null 2>&1; then
  echo "Connection to 8.8.8.8 succeeded."
else
  echo "Unable to reach 8.8.8.8."
  exit 1
fi
