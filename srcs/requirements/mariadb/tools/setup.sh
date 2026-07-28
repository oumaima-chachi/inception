#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB..."
fi
