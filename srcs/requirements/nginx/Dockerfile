FROM alpine:3.19

# --- FIX FOR 42 NETWORK ---
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# --- INSTALLATION ---
# On installe nginx et openssl
RUN apk update --no-cache && \
    apk add --no-cache nginx openssl

# --- CONFIGURATION DES DROITS ---
# Création du dossier racine et assignation à l'utilisateur 'nginx'
# Sur Alpine, l'utilisateur nginx existe déjà après l'installation
RUN mkdir -p /var/www/html && \
    chown -R nginx:nginx /var/www/html && \
    chmod -R 755 /var/www/html

# --- CONFIGURATION SSL ---
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mafourni.key \
    -out /etc/nginx/ssl/mafourni.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mafourni.42.fr/UID=mafourni"

# --- CONFIGURATION NGINX ---
RUN rm -rf /etc/nginx/conf.d/*

# Créer la configuration nginx avec le bloc http
RUN cat > /etc/nginx/nginx.conf << 'EOF'
worker_processes auto;
pid /var/run/nginx.pid;
user nginx;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log warn;

    sendfile on;
    keepalive_timeout 65;
    
    # Importer les fichiers de configuration du serveur
    include /etc/nginx/conf.d/*.conf;
}
EOF

# Créer le fichier de configuration du serveur
RUN mkdir -p /etc/nginx/conf.d

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# --- RUN ---
EXPOSE 443

# Lancement au premier plan
CMD ["nginx", "-g", "daemon off;"]