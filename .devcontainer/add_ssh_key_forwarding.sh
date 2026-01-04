#!/bin/bash

set -e

echo "🔑 Setting up SSH Key Forwarding..."
echo ""

# Check if running inside container
if [ ! -f "/.dockerenv" ]; then
    echo "⚠️  This script must be run inside the DevContainer"
    exit 1
fi

# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh
chmod 700 ~/.ssh

echo "📋 SSH Setup Options:"
echo ""
echo "Choose your SSH key setup method:"
echo "  1) Copy SSH keys from Windows host (recommended for JetBrains Gateway)"
echo "  2) Generate new SSH key pair in container"
echo "  3) Skip SSH setup"
echo ""
read -p "Enter choice [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "📂 Please copy your SSH keys manually:"
        echo ""
        echo "From Windows PowerShell or CMD, run:"
        echo "  docker cp ~/.ssh/id_rsa <container_name>:/home/vscode/.ssh/"
        echo "  docker cp ~/.ssh/id_rsa.pub <container_name>:/home/vscode/.ssh/"
        echo ""
        echo "Or use docker cp with the container ID:"
        echo "  docker ps  # to get container ID"
        echo "  docker cp C:\\Users\\YourName\\.ssh\\id_rsa <container_id>:/home/vscode/.ssh/"
        echo ""
        echo "After copying, run this script again to set permissions."
        echo ""

        # Check if keys exist
        if [ -f ~/.ssh/id_rsa ]; then
            echo "✅ SSH keys found! Setting permissions..."
            chmod 600 ~/.ssh/id_rsa
            chmod 644 ~/.ssh/id_rsa.pub
            echo "✅ Permissions set successfully"
        else
            echo "⚠️  No SSH keys found yet. Copy them and run this script again."
            exit 0
        fi
        ;;
    2)
        echo ""
        read -p "Enter your email for SSH key: " email
        ssh-keygen -t rsa -b 4096 -C "$email" -f ~/.ssh/id_rsa -N ""
        echo ""
        echo "✅ SSH key pair generated!"
        echo ""
        echo "📋 Your public key (add this to GitHub/GitLab):"
        echo ""
        cat ~/.ssh/id_rsa.pub
        echo ""
        ;;
    3)
        echo "⏭️  Skipping SSH setup"
        exit 0
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

# Configure SSH
echo ""
echo "🔧 Configuring SSH..."

# Create/update SSH config
cat > ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null

Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null

Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_rsa
EOF

chmod 600 ~/.ssh/config

# Start SSH agent
echo ""
echo "🚀 Starting SSH agent..."
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa 2>/dev/null || echo "⚠️  Could not add key to agent (this is OK if key is encrypted)"

# Test SSH connection
echo ""
echo "🧪 Testing SSH connection to GitHub..."
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo "✅ GitHub SSH connection successful!"
else
    echo "⚠️  GitHub SSH test failed (this might be OK if you haven't added the key to GitHub yet)"
fi

echo ""
echo "✅ SSH setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. If you generated a new key, add it to your Git provider (GitHub/GitLab)"
echo "  2. Test with: ssh -T git@github.com"
echo "  3. Clone repositories with: git clone git@github.com:user/repo.git"
echo ""
