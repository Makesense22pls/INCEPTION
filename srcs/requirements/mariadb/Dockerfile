FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y mariadb-server netcat-openbsd

RUN sed -i "s|127.0.0.1|0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

COPY tools/mdb-conf.sh /usr/local/bin/mdb-conf.sh

RUN chmod +x /usr/local/bin/mdb-conf.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mdb-conf.sh"]