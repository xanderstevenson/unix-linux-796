#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASHRC="$HOME/.bashrc"
BASH_ALIASES="$HOME/.bash_aliases"
BIN_DIR="$HOME/bin"

mkdir -p "$BIN_DIR"

# Move required scripts to ~/bin so they can run from any directory.
for file in create_user.sh delete_user.sh; do
  if [[ -f "$SCRIPT_DIR/$file" ]]; then
    mv "$SCRIPT_DIR/$file" "$BIN_DIR/$file"
    chmod +x "$BIN_DIR/$file"
  elif [[ -f "$BIN_DIR/$file" ]]; then
    echo "'$file' already exists in $BIN_DIR"
  else
    echo "Warning: '$file' was not found in $SCRIPT_DIR"
  fi
done

cp "$SCRIPT_DIR/aliases.sh" "$BASH_ALIASES"

if ! grep -q 'source ~/.bash_aliases' "$BASHRC" 2>/dev/null; then
  echo 'source ~/.bash_aliases' >> "$BASHRC"
fi

if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$BASHRC" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$BASHRC"
fi

if ! grep -q 'WGU_CUSTOM_PROMPT' "$BASHRC" 2>/dev/null; then
  cat <<'EOF' >> "$BASHRC"
# WGU_CUSTOM_PROMPT
# Green user, blue host, yellow directory, prompt symbol is a red $
PS1='\[\e[1;32m\]\u\[\e[0m\]@\[\e[1;34m\]\h \[\e[1;33m\]\w\[\e[0m\] \[\e[1;31m\]$\[\e[0m\] '
EOF
fi

echo "Shell configuration updated."
echo "Run: source ~/.bashrc"
echo "Then test from any directory with: create_user.sh <username> and delete_user.sh <username>"
