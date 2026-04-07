This project has been created as part of the 42 curriculum by mafourni

## Description

This project implements a complete Docker infrastructure for a WordPress website using MariaDB, Nginx.

## Instructions

Before running the project, add the following line to `/etc/hosts`:

```
127.0.0.1 mafourni.42.fr
```

The project is controlled via Makefile commands:

`make` - Builds and starts all services (MariaDB, WordPress, Nginx)

`make stop` - Stops all running containers

`make clean` - Removes containers and network

`make fclean` - Complete cleanup including volumes, images, and data directories

`make re` - Performs fclean followed by make (complete rebuild)

To access the website, navigate to:

https://mafourni.42.fr

## Project Structure

The project is organized as follows:

```
Inception/
├── Makefile
├── README.md
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│       │   ├── Dockerfile
│       │   ├── conf/50-server.cnf
│       │   └── tools/mdb-conf.sh
│       ├── nginx/
│       │   ├── Dockerfile
│       │   ├── conf/nginx.conf
│       │   └── ssl/ (generated at runtime)
│       └── wordpress/
│           ├── Dockerfile
│           ├── conf/
│           └── tools/wp-setup.sh
|────────USER_DOC.md
|────────DEV_DOC.md
```

## Docker and Project Overview

This project uses Docker to containerize a three-tier web application stack. Each service (database, web server, application) runs in its own lightweight container on Alpine Linux 3.19, reducing overhead while maintaining isolation.

The docker-compose.yml file orchestrates all services with automatic startup order management. MariaDB starts first as a dependency for WordPress, which in turn must be ready before Nginx can serve requests. Services communicate through a dedicated bridge network named "inception" rather than exposing ports unnecessarily.

Persistent data for both the database and WordPress files are stored in bind mounts (directories on the host machine), making data visible and accessible even when containers stop.

## Design Choices and Comparisons

### Virtual Machines vs Docker

Docker is much lighter because it shares the host kernel instead of virtualizing a full OS. This allows containers to start in seconds and use minimal RAM. We trade the strict isolation of a VM for massive gains in speed and resource efficiency.

### Secrets vs Environment Variables

Environment variables (.env) are easy to use but store data in plain text, which is a security risk. Docker Secrets encrypt sensitive data and only grant access to specific containers. We use .env here for simplicity, while acknowledging that Secrets are the standard for production.

### Docker Network vs Host Network

A Bridge network creates a private virtual space where containers talk to each other via their names (internal DNS), keeping them isolated from the host. Host networking is simpler but less secure as it exposes all ports directly. The Bridge approach is better for security and organization.

### Docker Volumes vs Bind Mounts

Bind Mounts link a container folder directly to a specific path on your disk (like /home/data). Unlike Volumes, which are managed by Docker, Bind Mounts offer total visibility and direct access to files, making it much easier to debug and manage data manually.

## Resources

https://docs.docker.com
https://docs.docker.com/compose
https://www.youtube.com/watch?v=KQUiICpM_u0
https://nginx.org/en/docs
https://nginx.org/en/docs/beginners_guide.html
https://wordpress.org/support/installation
https://learn.wordpress.org/
https://mariadb.com/docs
https://www.php.net/manual/en/install.fpm.php

## AI Usage

AI was used to ask questions at each step of the project, troubleshoot issues when stuck, and understand best practices. Helped guide the implementation and fix problems quickly.

