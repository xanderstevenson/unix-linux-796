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

fileSize() {
  local file="$1"
  if stat --version >/dev/null 2>&1; then
    stat -c%s "$file"
  else
    stat -f%z "$file"
  fi
}

TS="$(date +%Y%m%d_%H%M%S)"
GZ_FILE="etc_backup_${TS}.tar.gz"
BZ2_FILE="etc_backup_${TS}.tar.bz2"

run_as_root tar -czf "$GZ_FILE" -C / etc
run_as_root tar -cjf "$BZ2_FILE" -C / etc

GZ_SIZE=$(fileSize "$GZ_FILE")
BZ2_SIZE=$(fileSize "$BZ2_FILE")
DIFF=$((GZ_SIZE - BZ2_SIZE))

echo "gzip archive size : ${GZ_SIZE} bytes"
echo "bzip2 archive size: ${BZ2_SIZE} bytes"

if (( DIFF > 0 )); then
  echo "bzip2 file is smaller by ${DIFF} bytes"
elif (( DIFF < 0 )); then
  echo "gzip file is smaller by $((-DIFF)) bytes"
else
  echo "Both compressed files are the same size"
fi
