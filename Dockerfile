FROM php:7.4-cli

LABEL maintainer="JC Lecas<jeanchristophelecas@gmail.com>"

ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update \
    && apt-get install -y \
    ack-grep \
    bsdmainutils \
    dos2unix \
    gettext \
    git \
    gnupg \
    graphviz jq \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxml2-utils \
    libxslt-dev \
    libzip-dev \
    moreutils \
    nano \
    npm \
    python3 \
    python3-dev \
    python3-pip \
    shellcheck \
    sshpass \
    unzip \
    zip \
    && apt-get clean autoclean autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN \
    docker-php-ext-install bcmath gd gettext intl pdo_mysql soap sockets xsl zip

RUN \
    echo "memory_limit=1024M" > /usr/local/etc/php/conf.d/php.ini \
    && echo "phar.readonly=Off" >> /usr/local/etc/php/conf.d/php.ini

RUN \
    mkdir -p ~/.ssh \
    && chmod 700 ~/.ssh \
    && echo "" > ~/.ssh/known_hosts \
    && echo "Host *\n  StrictHostKeyChecking no\n  UserKnownHostsFile=/dev/null\n  LogLevel ERROR" > ~/.ssh/config

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN chmod +x /usr/bin/composer

RUN \
    curl -sL -o /usr/local/bin/jsawk http://github.com/micha/jsawk/raw/master/jsawk \
    && chmod +x /usr/local/bin/jsawk

RUN \
    curl -sL -o /usr/local/bin/slack https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack \
    && chmod +x /usr/local/bin/slack

RUN \
    composer create-project magento/magento-coding-standard --stability=dev ~/magento-coding-standard \
    && ln -s ~/magento-coding-standard/vendor/bin/phpcs /usr/local/bin/phpcs \
    && ln -s ~/magento-coding-standard/vendor/bin/phpcbf /usr/local/bin/phpcbf \
    && composer global require phpmd/phpmd \
    && ln -s ~/.config/composer/vendor/bin/phpmd /usr/local/bin/phpmd \
    && composer global require sebastian/phpcpd \
    && ln -s ~/.config/composer/vendor/bin/phpcpd /usr/local/bin/phpcpd \
    && composer global require phpmetrics/phpmetrics \
    && ln -s ~/.config/composer/vendor/bin/phpmetrics /usr/local/bin/phpmetrics

RUN \
    curl -sL -o ~/phpda.pubkey https://raw.githubusercontent.com/mamuz/PhpDependencyAnalysis/v1.3.1/download/phpda.pubkey \
    && curl -sL -o ~/phpda https://raw.githubusercontent.com/mamuz/PhpDependencyAnalysis/v1.3.1/download/phpda \
    && chmod +x ~/phpda

RUN \
    curl -sL -o /usr/local/bin/pdepend https://github.com/jakzal/pdepend/releases/download/2.5.2-jakzal-2/pdepend.phar \
    && chmod +x /usr/local/bin/pdepend

RUN \
    curl -sL -o /home/PHPCompatibility-9.3.5 https://github.com/PHPCompatibility/PHPCompatibility/archive/refs/tags/9.3.5.zip

#RUN \
#    curl -sL https://deb.nodesource.com/setup_10.x | bash \
#    && apt-get install -y nodejs \
#    && apt-get clean autoclean autoremove -y \
#    && rm -rf /var/lib/apt/lists/*

#RUN \
#    mkdir -p ~/eslint/standard ~/eslint/semistandard \
#    && npm install -g bower csslint eslint gulp grunt jshint jslint semistandard standard stylelint \
#    && npm install -g eslint-plugin-import eslint-plugin-node eslint-plugin-promise \
#    && npm install -g eslint-config-standard eslint-config-semistandard \
#    && npm install -g stylelint-config-standard \
#    && npm install -g jsonlint yaml-lint \
#    && echo '{"extends": ["standard"]}' > ~/eslint/standard/.eslintrc.json \
#    && echo '{"extends": ["semistandard"]}' > ~/eslint/semistandard/.eslintrc.json
