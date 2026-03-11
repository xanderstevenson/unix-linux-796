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

ROOT_BEFORE=$(df -k / | awk 'NR==2 {print $4}')

cleanDir() {
  local target_dir="$1"

  if [[ ! -d "$target_dir" ]]; then
    echo "Skipping '$target_dir' (directory not found)."
    return
  fi

  # Remove only contents, not the directory itself.
  run_as_root find "$target_dir" -mindepth 1 -exec rm -rf {} +
  echo "Cleaned: $target_dir"
}

DIRS_TO_CLEAN=("/var/log" "$HOME/.cache")

for dir in "${DIRS_TO_CLEAN[@]}"; do
  cleanDir "$dir"
done

ROOT_AFTER=$(df -k / | awk 'NR==2 {print $4}')
FREED_SPACE=$((ROOT_AFTER - ROOT_BEFORE))

if (( FREED_SPACE > 0 )); then
  echo "Disk space freed on /: ${FREED_SPACE} KB"
else
  echo "No significant disk space was freed"
fi
