FROM alpine:3.19

RUN echo "Alpine apk config" && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/main" > /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

RUN apk update --no-cache && \
    apk add --no-cache --allow-untrusted \
    mariadb \
    mariadb-client \
    netcat-openbsd \
    bash

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

COPY conf/50-server.cnf /etc/my.cnf

COPY tools/mdb-conf.sh /usr/local/bin/mdb-conf.sh
RUN chmod +x /usr/local/bin/mdb-conf.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mdb-conf.sh"]