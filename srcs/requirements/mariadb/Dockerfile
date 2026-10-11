FROM debian:bullseye

RUN apt update && apt install -y mariadb-server 

COPY ./conf/init.sh /init.sh 

RUN chmod +x /init.sh

CMD ["/init.sh"]
