# User Documentation - Inception Website

## Overview

Instructions for managing the Inception infrastructure and accessing the WordPress website.

## Quick Start

### Prerequisites

Add the domain to `/etc/hosts`:
```sh
echo "127.0.0.1 mafourni.42.fr" | sudo tee -a /etc/hosts
```

### Basic Commands

| Command | Action | Data |
|---------|--------|------|
| `make` | Start all services | Fresh |
| `make stop` | Stop services | Preserved |
| `make re` | Full restart | Cleaned |

## Accessing the Website

**Website:** `https://mafourni.42.fr` (HTTPS only)

**Admin Panel:** `https://mafourni.42.fr/wp-admin`

### Credentials

| Account | Username | Password/Email |
|---------|----------|----------------|
| Admin | `mafourni-wp` | `mafourni42` |
| User | `mafourni-worker` | `worker@student.42.fr` |

## Managing Credentials

Credentials stored in `srcs/.env`:

```
MYSQL_USER=mafourni-db-user
MYSQL_PASSWORD=mafourni42
MYSQL_ROOT_PASSWORD=mafourni42
```

**To change:** Edit `srcs/.env`, then run `make fclean` and `make`. ⚠️ This deletes all data.

## Data Persistence

Website and database files are stored at `/home/mafourni/data/`:
- `mariadb/` - Database files
- `wordpress/` - Website files

Data persists after `make stop`. Deleted only with `make fclean`.

## Checking Services

**Verify all services running:**
```sh
docker ps
```

Should show: `mariadb`, `wordpress`, `nginx`

**Check logs:**
```sh
docker compose -f srcs/docker-compose.yml logs -f [service_name]
```

**Test database:**
```sh
docker exec -it mariadb mysql -u mafourni-db-user -p inception_db
# Password: mafourni42
```

**Test website:**
```sh
curl -k https://mafourni.42.fr
```

## Troubleshooting

**Services won't start:**
- Check ports: `sudo lsof -i :443`
- Clean and restart: `make fclean && make`

**Can't access website:**
1. Domain in `/etc/hosts`? Check: `cat /etc/hosts`
2. Services running? Check: `docker ps`
3. Check nginx logs: `docker compose -f srcs/docker-compose.yml logs nginx`

**Database issues:**
```sh
docker compose -f srcs/docker-compose.yml logs mariadb
docker restart mariadb
```

**WordPress shows installation page:**
- Check logs: `docker compose -f srcs/docker-compose.yml logs wordpress`
- Verify DB initialized: `docker exec -it mariadb mysql -u mafourni-db-user -p inception_db -e "SHOW TABLES;"`
