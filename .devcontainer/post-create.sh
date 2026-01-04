#!/bin/bash

set -e

echo "🚀 Running post-create setup..."

# Check if composer.json exists
if [ -f "composer.json" ]; then
    echo "📦 Installing Composer dependencies..."
    composer install --no-interaction --prefer-dist --optimize-autoloader
else
    echo "⚠️  No composer.json found. Skipping Composer install."
    echo "💡 To create a new Symfony project, run:"
    echo "   symfony new . --version=7.4 --webapp"
fi

# Check if package.json exists (for Symfony Encore)
if [ -f "package.json" ]; then
    echo "📦 Installing npm dependencies..."
    npm install
else
    echo "⚠️  No package.json found. Skipping npm install."
fi

# Setup git safe directory
echo "🔒 Configuring git safe directory..."
git config --global --add safe.directory /workspace

# Display service information
echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Available Tools:"
echo "  - PHP 8.2 with Composer"
echo "  - Symfony CLI"
echo "  - Node.js & npm/yarn"
echo "  - Xdebug on port 9003"
echo ""
echo "🗄️  Database Configuration:"
echo "  The container supports MySQL, PostgreSQL, and SQLite."
echo "  Configure your DATABASE_URL in .env.local"
echo ""
echo "🔧 Optional: Install Claude Code CLI"
echo "  bash .devcontainer/install_claude_cli.sh"
echo ""
echo "📦 Useful Commands:"
echo "  - symfony console: Run Symfony console commands"
echo "  - symfony server:start: Start Symfony dev server"
echo "  - composer require <package>: Install PHP packages"
echo "  - npm run dev: Build frontend assets (if using Webpack Encore)"
echo ""
