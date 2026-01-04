FROM debian:bookworm-slim

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Basic utilities
    git \
    curl \
    wget \
    unzip \
    vim \
    nano \
    ca-certificates \
    gnupg \
    lsb-release \
    # Build tools
    build-essential \
    # PHP and common extensions
    php8.2 \
    php8.2-cli \
    php8.2-fpm \
    php8.2-common \
    # Database drivers for all major databases
    php8.2-mysql \
    php8.2-pgsql \
    php8.2-sqlite3 \
    # Symfony recommended extensions
    php8.2-intl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-curl \
    php8.2-zip \
    php8.2-gd \
    php8.2-bcmath \
    php8.2-opcache \
    # Additional useful extensions
    php8.2-redis \
    php8.2-apcu \
    php8.2-xdebug \
    # Node.js (for Symfony Webpack Encore)
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Configure PHP
RUN echo "memory_limit = 512M" > /etc/php/8.2/cli/conf.d/99-custom.ini && \
    echo "max_execution_time = 300" >> /etc/php/8.2/cli/conf.d/99-custom.ini && \
    echo "upload_max_filesize = 100M" >> /etc/php/8.2/cli/conf.d/99-custom.ini && \
    echo "post_max_size = 100M" >> /etc/php/8.2/cli/conf.d/99-custom.ini

# Configure Xdebug for development
RUN echo "xdebug.mode=develop,debug,coverage" > /etc/php/8.2/mods-available/xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /etc/php/8.2/mods-available/xdebug.ini && \
    echo "xdebug.client_port=9003" >> /etc/php/8.2/mods-available/xdebug.ini && \
    echo "xdebug.start_with_request=trigger" >> /etc/php/8.2/mods-available/xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /etc/php/8.2/mods-available/xdebug.ini

# Create a non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Install global npm packages for Symfony Encore
RUN npm install -g yarn

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER $USERNAME
