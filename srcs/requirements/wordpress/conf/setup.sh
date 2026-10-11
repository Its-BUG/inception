#!/bin/bash
set -e

# Create the web root directory if it does not exist
mkdir -p /var/www/html

# Move into the web root directory
cd /var/www/html

# Download and configure WordPress only if it is not already installed
# (important because /var/www/html is usually mounted as a Docker volume)
if [ ! -f wp-config.php ]; then

    # Download the latest official WordPress archive
    curl -O https://wordpress.org/latest.tar.gz

    # Extract the archive
    tar -xzf latest.tar.gz

    # Move WordPress files from ./wordpress/ to the current directory
    mv wordpress/* .

    # Remove temporary files
    rm -rf wordpress latest.tar.gz

    # Create the real WordPress configuration file from the provided template
    cp wp-config-sample.php wp-config.php

    # Replace placeholders with values coming from .env
    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/g" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/g" wp-config.php
    sed -i "s/localhost/${WP_DB_HOST}/g" wp-config.php
fi

# Wait until MariaDB is ready to accept connections
until mysql -h"$WP_DB_HOST" \
            -u"$MYSQL_USER" \
            -p"$MYSQL_PASSWORD" \
            "$MYSQL_DATABASE" \
            -e "SELECT 1" >/dev/null 2>&1
do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Install WordPress and create users only if WordPress is not already installed
if ! wp core is-installed --allow-root >/dev/null 2>&1; then

    # Install WordPress and create the administrator account
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    # Create a second non-admin user
    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=subscriber \
        --allow-root
fi

# Configure PHP-FPM to listen on TCP port 9000 instead of a UNIX socket
# This allows the NGINX container to connect using: wordpress:9000
sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' \
    /etc/php/7.4/fpm/pool.d/www.conf

# Start PHP-FPM in the foreground
# -F   -> stay in foreground (required by Docker)
# exec -> replace the shell so php-fpm becomes PID 1
exec php-fpm7.4 -F
