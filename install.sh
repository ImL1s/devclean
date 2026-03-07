#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
mkdir -p ~/.local/bin
cp "$SCRIPT_DIR/clean-orphans" ~/.local/bin/clean-orphans
chmod +x ~/.local/bin/clean-orphans
echo "✅ Installed clean-orphans to ~/.local/bin/"
echo "Make sure ~/.local/bin is in your PATH."
