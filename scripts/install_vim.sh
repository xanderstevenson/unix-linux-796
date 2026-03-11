#!/usr/bin/env bash

set -euo pipefail

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

if command -v vim >/dev/null 2>&1; then
  echo "Vim is already installed"
  exit 0
fi

if command -v apt-get >/dev/null 2>&1; then
  run_as_root apt-get update
  run_as_root apt-get install -y vim
elif command -v dnf >/dev/null 2>&1; then
  run_as_root dnf install -y vim
elif command -v yum >/dev/null 2>&1; then
  run_as_root yum install -y vim
elif command -v zypper >/dev/null 2>&1; then
  run_as_root zypper install -y vim
elif command -v pacman >/dev/null 2>&1; then
  run_as_root pacman -Sy --noconfirm vim
else
  echo "No supported package manager was found."
  exit 1
fi

echo "Vim installation completed."
