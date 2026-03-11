#!/usr/bin/env bash

set -euo pipefail

if ! command -v nslookup >/dev/null 2>&1; then
  echo "Error: nslookup is not installed."
  exit 1
fi

if nslookup example.com >/dev/null 2>&1; then
  echo "DNS resolution for example.com is working."
else
  echo "DNS resolution for example.com failed."
  exit 1
fi
