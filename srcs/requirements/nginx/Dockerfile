FROM debian:bullseye

# --- FIX RÉSEAU 42 (Crucial pour éviter l'erreur 100) ---
RUN echo 'Acquire::ForceIPv4 "true";' > /etc/apt/apt.conf.d/99force-ipv4

# --- INSTALLATION ---
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# --- CONFIGURATION SSL ---
RUN mkdir -p /etc/nginx/ssl

# Génération du certificat auto-signé
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mafourni.key \
    -out /etc/nginx/ssl/mafourni.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mafourni.42.fr/UID=mafourni"

# --- CONFIGURATION NGINX ---
# On supprime la config par défaut pour éviter les conflits
RUN rm -f /etc/nginx/sites-enabled/default

# On copie ta propre configuration
COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

# --- RUN ---
EXPOSE 443

# On utilise "daemon off" pour que le conteneur ne s'arrête pas immédiatement
CMD ["nginx", "-g", "daemon off;"]