all:
	@sudo mkdir -p /home/mafourni/data/mariadb
	@sudo mkdir -p /home/mafourni/data/wordpress
	@docker compose -f srcs/docker-compose.yml up -d --build

clean:
	@docker compose -f srcs/docker-compose.yml down

fclean: clean
	@docker system prune -af
	@sudo rm -rf /home/mafourni/data/mariadb/*
	@sudo rm -rf /home/mafourni/data/wordpress/*

re: fclean all

.PHONY: all clean fclean re