FROM debian:bullseye

RUN apt update && apt install -y \	
	php7.4 \
	php7.4-fpm \
	php7.4-mysql \
	curl \
	mariadb-client
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php

COPY ./conf/setup.sh /setup.sh

RUN chmod +x /setup.sh

CMD ["/setup.sh"]
