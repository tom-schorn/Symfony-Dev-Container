# Symfony 7.4 Development Container

A complete DevContainer for Symfony 7.4 development with PHP 8.2, optimized for **PHPStorm 2025.3**.

## Features

- **PHP 8.2** based on Debian Bookworm
- **Symfony 7.4** ready with all recommended extensions
- **Multi-Database Support**: MySQL, PostgreSQL, SQLite (PDO drivers installed)
- **Node.js & npm/yarn** for Symfony Webpack Encore
- **Xdebug** preconfigured for PHPStorm
- **Symfony CLI** preinstalled

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/) installed and running
- [PHPStorm 2025.3](https://www.jetbrains.com/phpstorm/) or [JetBrains Gateway](https://www.jetbrains.com/remote-development/gateway/)
- **Minimum System Requirements:**
  - 2+ CPU cores
  - 4GB+ RAM
  - 5GB+ disk space
- Java 17+ (for remote development)
- External database (optional) - MySQL, PostgreSQL, or MariaDB

## Getting Started

### 1. Clone Repository

```bash
git clone <repository-url>
cd Symfony-Dev-Container
```

### 2. Start DevContainer

#### With JetBrains Gateway:
1. Open JetBrains Gateway
2. "New Connection" → "Docker"
3. Select repository folder
4. PHPStorm will start automatically in the container

#### With VSCode (alternative):
1. Open repository in VSCode
2. When prompted, select "Reopen in Container"
3. Or: `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"

### 3. Create Symfony Project (if not exists yet)

If no Symfony project exists yet:

```bash
symfony new . --version=7.4 --webapp
```

Or for a minimal installation:

```bash
symfony new . --version=7.4
```

### 4. Configure Database

Create a `.env.local` file based on `.env.local.example`:

**For MySQL:**
```env
DATABASE_URL="mysql://user:password@host:3306/dbname?serverVersion=8.0"
```

**For PostgreSQL:**
```env
DATABASE_URL="postgresql://user:password@host:5432/dbname?serverVersion=15&charset=utf8"
```

**For SQLite (local development):**
```env
DATABASE_URL="sqlite:///%kernel.project_dir%/var/data.db"
```

### 5. Start Development Server

```bash
symfony server:start
```

The application will be available at http://localhost:8000.

## Optional Tools

### SSH Key Setup

To use Git with SSH (for GitHub, GitLab, etc.), run the setup script inside the container:

```bash
bash .devcontainer/add_ssh_key_forwarding.sh
```

This script will help you:
- Copy existing SSH keys from your host
- Or generate new SSH keys in the container
- Configure SSH for GitHub/GitLab
- Test your SSH connection

### GitHub CLI

To install GitHub CLI for enhanced GitHub integration:

```bash
bash .devcontainer/install_github_cli.sh
```

This provides commands like:
- `gh auth login` - Authenticate with GitHub
- `gh repo clone` - Clone repositories
- `gh pr create` - Create pull requests

**Note:** Both tools are optional. You can use HTTPS for Git operations without them.

## Available Services

| Service | Port | Description |
|---------|------|-------------|
| Symfony Dev Server | 8000 | Main application |
| Xdebug | 9003 | PHP Debugger for PHPStorm |

## Installed PHP Extensions

- **Database**: mysql, pgsql, sqlite3
- **Symfony Essentials**: intl, mbstring, xml, curl, zip
- **Performance**: opcache, apcu
- **Development**: xdebug
- **Additional**: gd, bcmath

## Xdebug Configuration (PHPStorm)

Xdebug is preconfigured with:
- **IDE Key**: PHPSTORM
- **Port**: 9003
- **Mode**: develop, debug, coverage
- **Start Mode**: trigger

### PHPStorm Setup:

Most settings are already preconfigured! The repository contains prepared PHPStorm configurations:

**Automatically configured:**
- ✅ PHP 8.2 Language Level
- ✅ Xdebug Port 9003
- ✅ IDE Key: PHPSTORM
- ✅ Symfony Plugin enabled
- ✅ PSR-12 Coding Standards

**Preconfigured Run Configurations:**
- **Symfony Server**: Starts the built-in PHP server
- **Symfony Console**: Runs Symfony console commands
- **PHPUnit**: Runs tests

**Manual Steps (if needed):**
1. If path mappings are not automatically detected:
   - Settings → PHP → Servers
   - Create server "localhost"
   - Path Mapping: `/workspace` → Project Root
2. Start debug session: Enable "Listen for PHP Debug Connections"

**Tip**: The Symfony plugin should be activated automatically. If not, enable it under Settings → Plugins → Symfony Support.

## PHPStorm 2025.3 Optimizations

This DevContainer is specifically optimized for PHPStorm 2025.3 with:

**Auto-installed Plugins:**
- PHPStan - Static analysis tool
- Psalm - Static analysis tool
- Symfony Support - Enhanced Symfony integration

**Environment Variables:**
- Xdebug automatically configured for remote debugging
- `XDEBUG_MODE` set for development, debugging, and coverage
- `XDEBUG_CONFIG` configured for Docker host communication

**Performance:**
- Minimal container startup (no heavy features)
- Cached Docker layers for fast rebuilds
- Optimized for 2+ cores, 4GB+ RAM systems

**Git Integration:**
- Git settings automatically synced from host `.gitconfig`
- SSH keys can be set up via `add_ssh_key_forwarding.sh`

## Useful Commands

```bash
# Composer
composer install
composer require <package>
composer update

# Symfony CLI
symfony console list
symfony console make:controller
symfony console doctrine:migrations:migrate

# Node.js / Webpack Encore
npm install
npm run dev          # Development build
npm run watch        # Watch mode
npm run build        # Production build

# Database
symfony console doctrine:database:create
symfony console doctrine:migrations:migrate
symfony console doctrine:fixtures:load
```

## Project Structure

```
.
├── .devcontainer/
│   ├── devcontainer.json           # DevContainer configuration (PHPStorm 2025.3)
│   ├── docker-compose.yml          # Docker Compose setup
│   ├── Dockerfile                  # PHP 8.2 Container Image
│   ├── add_ssh_key_forwarding.sh   # Optional: SSH setup script
│   └── install_github_cli.sh       # Optional: GitHub CLI installer
├── .idea/
│   ├── php.xml                     # PHP 8.2 configuration
│   ├── php-debug.xml               # Xdebug settings
│   ├── symfony2.xml                # Symfony plugin activation
│   ├── dataSources.xml             # Database templates
│   ├── inspectionProfiles/         # Code quality standards
│   └── runConfigurations/          # Preconfigured run configs
├── .env.local.example              # Example environment variables
├── .gitignore                      # Git ignore rules
└── README.md                       # This file
```


## Customization

### Add More PHP Extensions

Edit `.devcontainer/Dockerfile` and add extensions to the `apt-get install` list:

```dockerfile
php8.2-<extension-name>
```

Then rebuild the container: "Dev Containers: Rebuild Container"

### Additional Services

Edit `.devcontainer/docker-compose.yml` and add new services.

## Troubleshooting

### Port Already in Use
If port 8000 or 9003 is already in use, adjust the ports in `docker-compose.yml`.

### Composer/npm Errors
Make sure permissions are correct:
```bash
sudo chown -R vscode:vscode /workspace
```

### Xdebug Not Working
Check PHPStorm server configuration and ensure path mappings are correct.

## License

This repository is public and can be freely used.

## Contributing

Contributions are welcome! Please create a pull request or open an issue.
