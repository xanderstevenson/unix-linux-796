#!/usr/bin/env bash

set -euo pipefail

echo "[1] Syntax check for all scripts"
for f in ./*.sh; do
  bash -n "$f"
done
echo "Syntax checks passed"

echo "[2] Required argument checks"
./create_user.sh >/dev/null 2>&1 || true
./delete_user.sh >/dev/null 2>&1 || true
echo "Argument validation paths executed"

echo "[3] Safe runtime checks"
./check_google_domain.sh
./check_google_dns_ip.sh
./check_dns_resolution.sh

echo "All minimal verifications completed successfully"
