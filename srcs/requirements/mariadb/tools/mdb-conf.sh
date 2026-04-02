#!/bin/bash
set -e

# 1. Initialisation des tables système si nécessaire
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation des tables système MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql 2>/dev/null || true
fi

# 2. Configuration des utilisateurs et de la base de données
if [ ! -f /var/lib/mysql/.initialized ]; then
    echo "Première initialisation de MariaDB..."
    
    # Démarrer MariaDB normalement
    mysqld_safe &
    MYSQLD_PID=$!
    
    # Attendre que MariaDB soit prêt
    for i in {1..30}; do
        if mysqladmin ping -u root 2>/dev/null | grep "mysqld is alive" > /dev/null; then
            echo "MariaDB est prêt"
            break
        fi
        echo "Attente de MariaDB... ($i/30)"
        sleep 1
    done
    
    # Configurer les utilisateurs et la base de données
    mysql -u root <<'EOF'
-- Créer la base de données
DROP DATABASE IF EXISTS test;
CREATE DATABASE IF NOT EXISTS `inception_db`;

-- Supprimer les utilisateurs anonymes (parfois présents)
DELETE FROM mysql.user WHERE User='';

-- Créer l'utilisateur pour tous les hôtes
CREATE USER IF NOT EXISTS `mafourni-db-user`@'%' IDENTIFIED BY 'mafourni42';
CREATE USER IF NOT EXISTS `mafourni-db-user`@'localhost' IDENTIFIED BY 'mafourni42';

-- Attribuer les permissions
GRANT ALL PRIVILEGES ON `inception_db`.* TO `mafourni-db-user`@'%';
GRANT ALL PRIVILEGES ON `inception_db`.* TO `mafourni-db-user`@'localhost';

-- Configurer le root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'mafourni42';

-- Appliquer les changements
FLUSH PRIVILEGES;
EOF
    
    echo "Configuration terminée ✓"
    
    # Arrêter MariaDB proprement
    mysqladmin -u root -p'mafourni42' shutdown 2>/dev/null || true
    wait $MYSQLD_PID 2>/dev/null || true
    sleep 2
    
    # Marquer comme initialisé
    touch /var/lib/mysql/.initialized
else
    echo "Base de données déjà configurée"
fi

# 3. Démarrer MariaDB en premier plan
echo "Démarrage de MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql