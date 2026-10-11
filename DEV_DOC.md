# DEV_DOC.md

# Developer Documentation

## Purpose

This document explains how a developer can set up, build, run, debug, and maintain the Inception project from scratch.

---

## Prerequisites

The project is designed to be developed inside a Debian virtual machine, as required by the 42 subject.

### Required Software

- Debian 11 (Bullseye)
- Docker Engine
- Docker Compose plugin
- Make
- Git
- OpenSSH server (optional, for remote access)

### Recommended Development Workflow

1. Create a Debian virtual machine.
2. Install Docker and Docker Compose.
3. Clone the Git repository.
4. Configure `srcs/.env`.
5. Build and start the infrastructure.

---

## Repository Structure

```text
inception/
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   └── conf/
        │       └── init.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   └── conf/
        │       └── setup.sh
        └── nginx/
            ├── Dockerfile
            └── conf/
                └── default.conf
```

---

## Environment Setup

### Clone the Repository

```bash
git clone <repository-url>
cd inception
```

### Create the Environment File

Create `srcs/.env`:

```env
MYSQL_DATABASE=wordpress
MYSQL_USER=userl
MYSQL_PASSWORD=pass123
MYSQL_ROOT_PASSWORD=root123
WP_DB_HOST=mariadb:3306
DOMAIN_NAME=<login>.42.fr
WP_ADMIN_USER=admin
WP_ADMIN_PASSWORD=admin123
WP_ADMIN_EMAIL=admin@example.com
WP_USER=user
WP_USER_PASSWORD=user123
WP_USER_EMAIL=user@example.com
```

### Configure Hostname Resolution

Add the following entry to `/etc/hosts`:

```text
127.0.0.1    <login>.42.fr
```

---

## Installing Docker on Debian

### Update Packages

```bash
sudo apt update
sudo apt upgrade -y
```

### Install Dependencies

```bash
sudo apt install -y ca-certificates curl gnupg
```

### Add Docker GPG Key

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

### Add Docker Repository

```bash
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/debian \
$(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

### Install Docker

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Add Current User to the Docker Group

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Verify Installation

```bash
docker run hello-world
```

---

## Build and Launch the Project

### Using the Makefile

```bash
make
```

### Using Docker Compose Directly

```bash
docker compose -f srcs/docker-compose.yml up --build
```

---

## Stopping and Cleaning

### Stop Containers

```bash
make down
```

### Remove Containers and Volumes

```bash
make fclean
```

### Rebuild from Scratch

```bash
make re
```

---

## Useful Docker Commands

### List Running Containers

```bash
docker ps
```

### View All Containers

```bash
docker ps -a
```

### View Logs

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

### Enter a Container

```bash
docker exec -it mariadb bash
docker exec -it wordpress bash
docker exec -it nginx bash
```

### List Docker Images

```bash
docker images
```

### List Volumes

```bash
docker volume ls
```

### Inspect a Network

```bash
docker network inspect srcs_inception
```

---

## Data Persistence

### Docker Volumes Used

| Volume | Mounted Path | Purpose |
|------|------|------|
| `db_data` | `/var/lib/mysql` | MariaDB database files |
| `wp_data` | `/var/www/html` | WordPress files and uploads |

### Why Data Persists

Volumes are stored outside container filesystems. Recreating containers does not delete the data unless the volumes are explicitly removed.

---

## Networking

All services are attached to a dedicated bridge network named `inception`.

Containers communicate by service name:

- `mariadb:3306`
- `wordpress:9000`
- `nginx:443`

Docker provides an internal DNS server that resolves these names automatically.

---

## Build Contexts

Each service is built from its own directory:

- `requirements/mariadb`
- `requirements/wordpress`
- `requirements/nginx`

The `build:` directive in `docker-compose.yml` defines the context sent to Docker during image creation.

---

## Configuration Files

### MariaDB

- `requirements/mariadb/Dockerfile`
- `requirements/mariadb/conf/init.sh`

### WordPress

- `requirements/wordpress/Dockerfile`
- `requirements/wordpress/conf/setup.sh`

### NGINX

- `requirements/nginx/Dockerfile`
- `requirements/nginx/conf/default.conf`

---

## Debugging Tips

### Test WordPress to MariaDB Connectivity

```bash
docker exec -it wordpress bash
mysql -h mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"
```

### Test PHP-FPM Port

```bash
docker exec -it wordpress ss -ltnp | grep 9000
```

### Test NGINX Configuration

```bash
docker exec -it nginx nginx -t
```

### Test HTTPS Response

```bash
curl -k https://<login>.42.fr
```

---

## Development Notes

### One Process Per Container

Each container runs one main foreground process:

- `mysqld_safe`
- `php-fpm7.4 -F`
- `nginx -g 'daemon off;'`

Docker keeps containers alive as long as PID 1 is running.

### Configuration Injection

The `.env` file provides values that are injected into containers and used to generate runtime configuration files.

### Shared WordPress Volume

Both NGINX and WordPress mount `wp_data:/var/www/html` so that WordPress can write files and NGINX can serve static assets directly.

---

## Rebuilding a Single Service

```bash
docker compose -f srcs/docker-compose.yml build wordpress
docker compose -f srcs/docker-compose.yml up -d wordpress
```

---

## Resetting Volumes Manually

```bash
docker compose -f srcs/docker-compose.yml down -v
```

or:

```bash
docker volume rm srcs_db_data srcs_wp_data
```

---

## Conclusion

This document provides all information needed to reproduce the environment, build the infrastructure, inspect containers, debug service communication, and maintain persistent data during development.
