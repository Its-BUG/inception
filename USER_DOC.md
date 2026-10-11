# USER_DOC.md

# User Documentation

## Overview

This document explains how to use and administer the Inception stack.

The stack provides three services:

- NGINX (HTTPS web server)
- WordPress (website and administration panel)
- MariaDB (database)

---

## Start the Project

```bash
make
```

This command builds all Docker images and starts the containers.

---

## Stop the Project

```bash
make down
```

---

## Remove All Data

```bash
make fclean
```

This removes containers, networks, and Docker volumes.

---

## Access the Website

Add this entry to your hosts file:

```text
127.0.0.1    <login>.42.fr
```

Open the website:

```text
https://<login>.42.fr
```

---

## Access the WordPress Administration Panel

Open:

```text
https://<login>.42.fr/wp-admin
```

Log in using the WordPress administrator credentials defined during installation.

---

## Credentials Location

Credentials are stored in:

```text
srcs/.env
```

Typical variables include:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=userl
MYSQL_PASSWORD=pass123
MYSQL_ROOT_PASSWORD=root123
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin123
```

---

## Check Running Services

```bash
docker ps
```

Expected containers:

- nginx
- wordpress
- mariadb

---

## View Logs

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

---

## Restart the Project

```bash
make down
make
```

---

## Verify Website Availability

```bash
curl -k https://<login>.42.fr
```

---

## Verify Database Connectivity

```bash
docker exec -it wordpress bash
mysql -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
```

---

## Persistent Data

The following Docker volumes preserve data:

- `db_data` — MariaDB database files
- `wp_data` — WordPress files and uploads

Data remains available even if containers are recreated.
