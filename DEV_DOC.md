# Developer Documentation

## Setup

Prerequisites: Docker and Docker Compose installed

Add to `/etc/hosts`:
```
127.0.0.1 mafourni.42.fr
```

Edit `srcs/.env` if needed (database/WordPress credentials)

## Run Project

```sh
make          # Build and start
make stop     # Stop services (data persists)
make clean    # Remove containers (data persists)
make fclean   # Full cleanup including data
make re       # Full rebuild
```

## Data Storage

Data is stored in `/home/mafourni/data/`:
- `mariadb/` - Database files
- `wordpress/` - WordPress files

Data persists with `make stop` and `make clean`. Only `make fclean` deletes it.

## Essential Commands

```sh
docker compose -f srcs/docker-compose.yml ps              # List services
docker compose -f srcs/docker-compose.yml logs -f         # View logs
docker compose -f srcs/docker-compose.yml exec mariadb bash  # Shell access
docker exec mariadb mysql -u mafourni-db-user -pmafourni42 inception_db  # Database
curl -k https://mafourni.42.fr  # Test HTTPS
```

## Configuration

Edit `srcs/.env` for database name, credentials, WordPress admin username. Then run:

```sh
make fclean && make
```

## Project Structure

```
srcs/
├── docker-compose.yml
├── .env
└── requirements/
    ├── mariadb/Dockerfile
    ├── nginx/Dockerfile
    └── wordpress/Dockerfile
```

