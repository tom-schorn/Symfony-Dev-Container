#!/bin/bash

set -e

echo "🚀 Installing Claude Code CLI..."
echo ""

# Install Claude Code CLI
if command -v claude &> /dev/null; then
    echo "✅ Claude Code CLI is already installed"
    claude --version 2>/dev/null || echo "Version info not available"
else
    echo "⬇️  Downloading Claude Code CLI..."

    # Download and install Claude Code CLI
    curl -fsSL https://raw.githubusercontent.com/anthropics/claude-code/main/install.sh | sh

    echo "✅ Claude Code CLI installed successfully"
    echo "ℹ️  Run 'claude --version' to verify installation"
fi

echo ""
echo "✅ Installation complete!"
echo ""
echo "🔧 Usage:"
echo "  - claude --help"
echo ""
