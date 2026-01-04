#!/bin/bash

set -e

echo "🚀 Installing GitHub CLI..."
echo ""

# Check if GitHub CLI is already installed
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI is already installed"
    gh --version
    exit 0
fi

# Install GitHub CLI
echo "⬇️  Downloading GitHub CLI..."

# Add GitHub CLI repository
(type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Update and install
sudo apt update
sudo apt install gh -y

echo ""
echo "✅ GitHub CLI installed successfully!"
echo ""
gh --version
echo ""
echo "🔧 Usage:"
echo "  - gh auth login    # Authenticate with GitHub"
echo "  - gh repo clone    # Clone repositories"
echo "  - gh pr create     # Create pull requests"
echo "  - gh --help        # Show all commands"
echo ""
