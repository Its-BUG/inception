
# Inception

## Description

Inception is a DevOps and system administration project from the 42 curriculum created by \<saamouss>.The objective is to build a secure and containerized web infrastructure using Docker and Docker Compose.

The mandatory stack contains three services:

- NGINX with HTTPS (TLS)
- WordPress with PHP-FPM
- MariaDB

Each service runs in its own Docker container, communicates through a dedicated Docker network, and stores persistent data in Docker volumes.

### Architecture Overview

```text
Browser
   ↓ HTTPS (443)
NGINX
   ↓ FastCGI (wordpress:9000)
WordPress + PHP-FPM
   ↓ MySQL protocol (mariadb:3306)
MariaDB
```

### Project Goal

The project demonstrates:

- Docker image creation
- Multi-container orchestration
- HTTPS and TLS certificates
- Reverse proxy configuration
- Persistent storage with volumes
- Service communication through Docker networks
- Configuration injection using environment variables

---

## Instructions

### Build and Start the Project

```bash
make
```

or directly:

```bash
docker compose -f srcs/docker-compose.yml up --build
```

### Stop the Project

```bash
make down
```

### Remove Containers and Volumes

```bash
make fclean
```

### Access the Website

Add the following entry to your hosts file:

```text
127.0.0.1    <login>.42.fr
```

Then open:

```text
https://<login>.42.fr
```

---

## Docker and Project Design

### Why Docker?

Docker packages applications and their dependencies into isolated containers.

Benefits include:

- Reproducible environments
- Lightweight deployment
- Service isolation
- Fast startup
- Simplified management

### Project Sources

The project includes custom Dockerfiles and configuration files for:

- MariaDB
- WordPress + PHP-FPM
- NGINX
- Docker Compose orchestration
- Environment variable configuration

### Main Design Choices

- One service per container
- Dedicated bridge network (`inception`)
- Persistent Docker volumes (`db_data`, `wp_data`)
- Self-signed TLS certificate generated with OpenSSL
- Configuration driven by `.env`

---

## Required Comparisons

### Virtual Machines vs Docker

| Virtual Machines            | Docker                |
| --------------------------- | --------------------- |
| Full guest operating system | Share the host kernel |
| Heavy resource usage        | Lightweight           |
| Slower startup              | Fast startup          |
| Large disk footprint        | Small images          |

### Secrets vs Environment Variables

| Secrets                            | Environment Variables                                                |
| ---------------------------------- | -------------------------------------------------------------------- |
| Designed for highly sensitive data | Used for general configuration                                       |
| Better security controls           | Simple and convenient                                                |
| Common in production orchestration | Common iN small projectC|

### Docker Network vs Host Network

| Docker Bridge Network                    | Host Network                  |
| ---------------------------------------- | ----------------------------- |
| Isolated from the host                   | Shares the host network stack |
| Internal DNS by service name             | No service-name DNS           |
| Recommended for multi-container projects | Used for special cases        |

### Docker Volumes vs Bind Mounts

| Docker Volumes                        | Bind Mounts                         |
| ------------------------------------- | ----------------------------------- |
| Managed by Docker                     | Direct mapping to host paths        |
| Portable and easy to back up          | Depend on specific host directories |
| Ideal for persistent application data | Useful for development              |

---

## Resources

### Official Documentation

- Docker Documentation: [https://docs.docker.com/](https://docs.docker.com/)
- Docker Compose Documentation: [https://docs.docker.com/compose/](https://docs.docker.com/compose/)
- NGINX Documentation: [https://nginx.org/en/docs/](https://nginx.org/en/docs/)
- WordPress Documentation: [https://wordpress.org/documentation/](https://wordpress.org/documentation/)
- MariaDB Documentation: [https://mariadb.com/kb/en/](https://mariadb.com/kb/en/)
- OpenSSL Documentation: [https://www.openssl.org/docs/](https://www.openssl.org/docs/)

### AI Usage

Artificial intelligence tools were used as learning and documentation assistants.

- Tool used: ChatGPT (OpenAI)
- Tasks assisted:
  - Explaining Docker concepts
  - Understanding NGINX, PHP-FPM, and MariaDB interactions
  - Reviewing Dockerfiles and shell scripts
  - Improving technical documentation

All implementation, configuration, and testing were completed manually after understanding the concepts.

---
