# Chemins vers les dossiers de données
DATA_PATH = /home/mafourni/data

all:
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/wordpress
	@docker compose -f srcs/docker-compose.yml up -d --build

stop:
	@docker compose -f srcs/docker-compose.yml stop

clean:
	@docker compose -f srcs/docker-compose.yml down

fclean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all
	@docker system prune -af
	@find $(DATA_PATH) -type d -exec chmod 755 {} \; 2>/dev/null || true
	@find $(DATA_PATH) -type f -exec chmod 644 {} \; 2>/dev/null || true
	@rm -rf $(DATA_PATH) 2>/dev/null || true
	@echo "L'infrastructure et les volumes ont été supprimés."

re: fclean all

.PHONY: all stop clean fclean re