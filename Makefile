# Chemins vers les dossiers de données
DATA_PATH = /home/mafourni/data

all:
	@sudo mkdir -p $(DATA_PATH)/mariadb
	@sudo mkdir -p $(DATA_PATH)/wordpress
	@docker compose -f srcs/docker-compose.yml up -d --build

stop:
	@docker compose -f srcs/docker-compose.yml stop

clean:
	@docker compose -f srcs/docker-compose.yml down

fclean:
	@docker compose -f srcs/docker-compose.yml down -v --rmi all
	@docker system prune -af
	@sudo rm -rf $(DATA_PATH)
	@echo "L'infrastructure et les volumes ont été supprimés."

re: fclean all

.PHONY: all stop clean fclean re