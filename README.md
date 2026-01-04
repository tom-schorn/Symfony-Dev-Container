# Symfony 7.4 Development Container

A complete DevContainer for Symfony 7.4 development with PHP 8.2, optimized for PHPStorm.

## Features

- **PHP 8.2** based on Debian Bookworm
- **Symfony 7.4** ready with all recommended extensions
- **Multi-Database Support**: MySQL, PostgreSQL, SQLite (PDO drivers installed)
- **Node.js & npm/yarn** for Symfony Webpack Encore
- **Xdebug** preconfigured for PHPStorm
- **Symfony CLI** preinstalled

## Prerequisites

- [Docker](https://www.docker.com/products/docker-desktop/)
- [JetBrains Gateway](https://www.jetbrains.com/remote-development/gateway/) or PHPStorm with Remote Development Plugin
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

## SSH Key Forwarding

The DevContainer automatically forwards your SSH keys from the host machine, allowing you to:
- Push/pull from Git repositories without re-entering credentials
- Use SSH authentication for Composer packages from private repositories
- Access remote servers via SSH

**How it works:**
- Your `~/.ssh` directory is mounted into the container
- The SSH agent socket is forwarded automatically
- All SSH keys and configurations are available inside the container

**Setup:**
1. Ensure your SSH agent is running on your host machine:
   ```bash
   # Linux/macOS
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_rsa

   # Windows (PowerShell)
   Start-Service ssh-agent
   ssh-add ~\.ssh\id_rsa
   ```

2. Your SSH keys are automatically available in the container:
   ```bash
   # Test SSH connection
   ssh -T git@github.com
   ```

**Note:** SSH keys are mounted read-only for security. The container never modifies your host SSH configuration.

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
│   ├── devcontainer.json    # DevContainer configuration
│   ├── docker-compose.yml   # Services (Redis, Mailhog)
│   ├── Dockerfile           # PHP Container Image
│   └── post-create.sh       # Setup script
├── .idea/
│   ├── php.xml              # PHP 8.2 configuration
│   ├── php-debug.xml        # Xdebug settings
│   ├── symfony2.xml         # Symfony plugin activation
│   ├── dataSources.xml      # Database templates
│   ├── inspectionProfiles/  # Code quality standards
│   └── runConfigurations/   # Preconfigured run configs
├── .env.local.example       # Example environment variables
├── .gitignore               # Git ignore rules
└── README.md                # This file
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
If port 8000, 8025, or 6379 is already in use, adjust the ports in `docker-compose.yml`.

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
