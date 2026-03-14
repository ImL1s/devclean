#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.local/bin
# 移除舊版 clean-orphans（如存在）
[ -f ~/.local/bin/clean-orphans ] && rm -f ~/.local/bin/clean-orphans
cp "$SCRIPT_DIR/devclean" ~/.local/bin/devclean
chmod +x ~/.local/bin/devclean
echo "✅ Installed devclean to ~/.local/bin/"
echo "Make sure ~/.local/bin is in your PATH."
