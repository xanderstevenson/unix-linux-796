#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="update.log"

run_as_root() {
  if [[ $EUID -eq 0 ]]; then
    "$@"
  elif command -v sudo >/dev/null 2>&1; then
    sudo "$@"
  else
    echo "Error: this script needs root privileges. Run as root or install sudo."
    exit 1
  fi
}

{
  echo "=== Package update started at $(date) ==="

  if command -v apt-get >/dev/null 2>&1; then
    run_as_root apt-get update
    run_as_root apt-get upgrade -y
  elif command -v dnf >/dev/null 2>&1; then
    run_as_root dnf upgrade --refresh -y
  elif command -v yum >/dev/null 2>&1; then
    run_as_root yum update -y
  elif command -v zypper >/dev/null 2>&1; then
    run_as_root zypper update -y
  elif command -v pacman >/dev/null 2>&1; then
    run_as_root pacman -Syu --noconfirm
  else
    echo "No supported package manager was found."
    exit 1
  fi

  echo "=== Package update finished at $(date) ==="
} | tee "$LOG_FILE"

echo "Output saved to $LOG_FILE"
