FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y nginx openssl

	# Supprime la config par défaut avant de lancer Nginx
RUN rm -f /etc/nginx/sites-enabled/default

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/mafourni.key \
    -out /etc/nginx/ssl/mafourni.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mafourni.42.fr/UID=mafourni"

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]