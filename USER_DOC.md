# User Documentation

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
| Admin | `mafourni-wp` | 
| User | `mafourni-worker`  |

**To change:** Edit `srcs/.env`, then run `make fclean` and `make`. ⚠️ This deletes all data.

## Changing the Port

**Default:** Port 443 (HTTPS)

**To change the port:**

1. Edit `srcs/docker-compose.yml`
2. Find the `nginx` service and the `ports` section
3. Change `"443:443"` to your desired port (e.g., `"8443:443"`)
4. Rebuild and restart:

```sh
make re
```

5. Access the website on the new port:

```sh
curl -k https://localhost:8443
```

**Example:** Changing to port 8443:
```yaml
nginx:
  ports:
    - "8443:443"  # Changed from "443:443"
```

After `make re`, access via `https://mafourni.42.fr:8443` (add domain to `/etc/hosts` if needed).

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
**CHECK TLS**
curl -v -k https://mafourni.42.fr 2>&1 | grep "TLSv"

Should show: `mariadb`, `wordpress`, `nginx`

**Check logs:**
```sh
docker compose -f srcs/docker-compose.yml logs -f [service_name]
```

**Test database:**
```sh
# Se connecter
docker exec -it mariadb mysql -u root -p

# Taper le mot de passe
# Puis dans le shell MariaDB :

SHOW DATABASES;
USE wordpress;
SHOW TABLES;

# Quitter
exit;
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
