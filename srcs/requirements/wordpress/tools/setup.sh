#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(grep WP_ADMIN_PASSWORD /run/secrets/credentials | cut -d '=' -f2-)
WP_USER_PASSWORD=$(grep WP_USER_PASSWORD /run/secrets/credentials | cut -d '=' -f2-)

while ! mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
    sleep 1
done

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."
fi
