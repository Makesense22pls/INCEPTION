FROM alpine:3.19

# --- FIX FOR 42 NETWORK (Future system date) ---
RUN echo "Alpine apk config" && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# --- INSTALLATION ---
RUN apk update --no-cache && \
    apk add --no-cache --allow-untrusted \
    mariadb \
    mariadb-client \
    netcat-openbsd \
    bash

# --- CONFIGURATION ---
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# Copier le fichier de configuration
COPY conf/50-server.cnf /etc/my.cnf

# --- SCRIPT D'INITIALISATION ---
COPY tools/mdb-conf.sh /usr/local/bin/mdb-conf.sh
RUN chmod +x /usr/local/bin/mdb-conf.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mdb-conf.sh"]