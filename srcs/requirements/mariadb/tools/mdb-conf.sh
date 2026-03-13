#!/bin/bash
set -e

# 1. Initialisation si le dossier est vide
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation des tables système MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --rpm
fi

# 2. Vérification de la persistance
# Si la base de données existe déjà, on ne refait pas la config
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    echo "Lancement temporaire pour la configuration initiale..."
    mysqld_safe --datadir=/var/lib/mysql --skip-networking &

    echo "Attente du démarrage de MariaDB..."
    until mysqladmin ping >/dev/null 2>&1; do
        echo "MariaDB n'est pas encore prêt..."
        sleep 2
    done

    echo "Configuration des utilisateurs et de la base de données..."
    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "Arrêt de l'instance temporaire..."
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    # On attend que le processus s'arrête vraiment
    sleep 2
else
    echo "Base de données '${MYSQL_DATABASE}' déjà existante. Saut de la config."
fi

# 3. Lancement final au premier plan (Crucial pour Docker)
echo "Lancement final de MariaDB..."
exec mysqld_safe --datadir=/var/lib/mysql