FROM debian:bullseye

RUN apt update && apt install -y nginx openssl 

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048\
	-keyout /etc/nginx/ssl/inception.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=MA/ST=Morocco/L=Benguerir/O=42/CN=${DOMAIN_NAME}"
 
COPY ./conf/default.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
