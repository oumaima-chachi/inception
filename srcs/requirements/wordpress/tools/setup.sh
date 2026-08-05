#!/bin/bash
set -e

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(grep WP_ADMIN_PASSWORD /run/secrets/credentials | cut -d '=' -f2-)
