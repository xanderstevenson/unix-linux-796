#!/usr/bin/env bash

set -euo pipefail

if ping -c 4 google.com >/dev/null 2>&1; then
  echo "Network is up."
else
  echo "Network is down or google.com is unreachable."
  exit 1
fi
