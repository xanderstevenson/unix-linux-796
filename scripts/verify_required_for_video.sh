#!/usr/bin/env bash

set -euo pipefail

REQUIRED_SCRIPTS=(
  "create_user.sh"
  "delete_user.sh"
  "configure_shell_env.sh"
  "install_vim.sh"
  "update_packages.sh"
  "check_google_domain.sh"
  "check_google_dns_ip.sh"
  "check_dns_resolution.sh"
  "disk_cleanup.sh"
  "archive_compare.sh"
)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="$(cd "$SCRIPT_DIR/../docs" && pwd)"

echo "== D796 required-only precheck =="

echo
echo "[1/5] Confirm required script files exist"
for script in "${REQUIRED_SCRIPTS[@]}"; do
  if [[ -f "$SCRIPT_DIR/$script" ]]; then
    echo "OK  $script"
  else
    echo "MISSING  $script"
    exit 1
  fi
done

echo
echo "[2/5] Syntax check (bash -n)"
for script in "${REQUIRED_SCRIPTS[@]}"; do
  bash -n "$SCRIPT_DIR/$script"
  echo "OK  $script"
done

echo
echo "[3/5] Required docs check"
if [[ -f "$DOCS_DIR/network_flowchart.md" ]]; then
  echo "OK  docs/network_flowchart.md"
else
  echo "MISSING  docs/network_flowchart.md"
  exit 1
fi

echo
echo "[4/5] Safe validation for required argument checks"
set +e
"$SCRIPT_DIR/create_user.sh" >/dev/null 2>&1
create_rc=$?
"$SCRIPT_DIR/delete_user.sh" >/dev/null 2>&1
delete_rc=$?
set -e

if [[ $create_rc -ne 0 ]]; then
  echo "OK  create_user.sh fails without username (expected)"
else
  echo "FAIL  create_user.sh should fail without username"
  exit 1
fi

if [[ $delete_rc -ne 0 ]]; then
  echo "OK  delete_user.sh fails without username (expected)"
else
  echo "FAIL  delete_user.sh should fail without username"
  exit 1
fi

echo
echo "[5/5] Quick network checks (non-blocking)"
for script in check_google_domain.sh check_google_dns_ip.sh check_dns_resolution.sh; do
  if "$SCRIPT_DIR/$script" >/dev/null 2>&1; then
    echo "OK  $script"
  else
    echo "WARN  $script failed in this environment (retest inside your Linux VM)"
  fi
done

echo
echo "Precheck complete. Use only these required scripts in the video + paper:"
printf '%s\n' "${REQUIRED_SCRIPTS[@]}"
