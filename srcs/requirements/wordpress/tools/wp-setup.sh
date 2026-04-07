#!/bin/bash
set -e

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
    echo "[ERROR] Variables MariaDB manquantes"
    exit 1
fi

if [ -z "$WP_URL" ] || [ -z "$WP_ADMIN_USER" ] || [ -z "$WP_ADMIN_PASSWORD" ]; then
    echo "[ERROR] Variables WordPress manquantes"
    exit 1
fi

# Attendre MariaDB
max_attempts=50
attempt=0
while ! mysql -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1" >/dev/null 2>&1; do
    attempt=$((attempt+1))
    [ $attempt -gt $max_attempts ] && exit 1
    sleep 1
done

cd /var/www/html

if [ ! -f "wp-config.php" ]; then
    php -d memory_limit=512M /usr/local/bin/wp core download --allow-root --force
    php -d memory_limit=512M /usr/local/bin/wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb
    php -d memory_limit=512M /usr/local/bin/wp core install --allow-root \
        --url="https://${WP_URL}" --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}
    php -d memory_limit=512M /usr/local/bin/wp option update home "https://${WP_URL}" --allow-root
    php -d memory_limit=512M /usr/local/bin/wp option update siteurl "https://${WP_URL}" --allow-root
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html
find /var/www/html -type f -exec chmod 644 {} \;

exec php-fpm83 -F