#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE_DIR="$HOME/Development/dotfiles/_templates/obsidian"
VAULT_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Vile"
TARGET_DIR="$VAULT_DIR/templates"

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Missing source templates directory: $SOURCE_DIR"
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SOURCE_DIR"/*.md "$TARGET_DIR"/

mkdir -p "$VAULT_DIR/daily"
mkdir -p "$VAULT_DIR/maps"

echo "Obsidian templates synced to $TARGET_DIR"
