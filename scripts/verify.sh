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
  shellcheck -x "${bash_files[@]}"
else
  echo "[verify] shellcheck not found; skipping shellcheck step."
fi

echo "[verify] Checking Codex global instructions package..."
test -f "codex/.codex/AGENTS.md"
grep -Eq 'for config_dir in .*codex' install_common.sh

if ! command -v stow >/dev/null 2>&1; then
  echo "[verify] stow is required for the Codex package link check." >&2
  exit 1
fi

stow_target="$(mktemp -d)"
trap 'rm -rf -- "$stow_target"' EXIT
mkdir -p "$stow_target/.codex"
stow -d "$ROOT_DIR" -t "$stow_target" codex
test -L "$stow_target/.codex/AGENTS.md"
cmp -s "$stow_target/.codex/AGENTS.md" "$ROOT_DIR/codex/.codex/AGENTS.md"

echo "[verify] Checking safe Stow target preparation..."
source "$ROOT_DIR/lib/platform.sh"
managed_source="$stow_target/managed-AGENTS.md"
foreign_source="$stow_target/foreign-AGENTS.md"
managed_target="$stow_target/.codex/managed-AGENTS.md"
foreign_target="$stow_target/.codex/foreign-AGENTS.md"
printf '%s\n' managed > "$managed_source"
printf '%s\n' foreign > "$foreign_source"
ln -s "$managed_source" "$managed_target"
ln -s "$foreign_source" "$foreign_target"

prepare_stow_file "$managed_source" "$managed_target"
foreign_check_output="$stow_target/foreign-check.log"
if prepare_stow_file "$managed_source" "$foreign_target" >"$foreign_check_output" 2>&1; then
  echo "[verify] foreign symlink was accepted unexpectedly." >&2
  exit 1
fi
grep -q 'is a symlink managed outside this dotfiles repository' "$foreign_check_output"
test -L "$foreign_target"
cmp -s "$foreign_target" "$foreign_source"

echo "[verify] All checks passed."
