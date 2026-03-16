FROM debian:bookworm

# --- FIX RÉSEAU 42 ---
# Force l'IPv4 car l'IPv6 de l'école fait souvent timeout sur Docker
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# --- INSTALLATION ---
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server \
    netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

# --- CONFIGURATION ---
# Autorise MariaDB à écouter sur toutes les interfaces (nécessaire pour Docker)
RUN sed -i "s|127.0.0.1|0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

# Création du dossier pour le socket MySQL avec les bons droits
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# --- SCRIPT D'INITIALISATION ---
COPY tools/mdb-conf.sh /usr/local/bin/mdb-conf.sh
RUN chmod +x /usr/local/bin/mdb-conf.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mdb-conf.sh"]