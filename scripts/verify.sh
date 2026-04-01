#!/bin/bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

echo "[verify] Running bash syntax checks..."
bash_files=()
while IFS= read -r file; do
  bash_files+=("$file")
done < <(find . -type f -name "*.sh" -not -path "./.git/*" | sort)
for file in "${bash_files[@]}"; do
  bash -n "$file"
done

echo "[verify] Running zsh syntax checks..."
zsh_files=(
  "zsh/.zshenv"
  "zsh/.zshrc"
  "zsh/.zshrc.codex"
)

for file in "${zsh_files[@]}"; do
  if [ -f "$file" ]; then
    zsh -n "$file"
  fi
done

if command -v shellcheck >/dev/null 2>&1; then
  echo "[verify] Running shellcheck..."
  shellcheck "${bash_files[@]}"
else
  echo "[verify] shellcheck not found; skipping shellcheck step."
fi

echo "[verify] All checks passed."
