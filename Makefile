NAME = inception

all:
	mkdir -p $(HOME)/data/mariadb
	mkdir -p $(HOME)/data/wordpress
	docker compose -f srcs/docker-compose.yml up --build

up:
	docker compose -f srcs/docker-compose.yml up

down:
	docker compose -f srcs/docker-compose.yml down

clean:
	docker compose -f srcs/docker-compose.yml down -v

fclean: clean
	docker system prune -af
	sudo rm -rf $(HOME)/data/mariadb $(HOME)/data/wordpress

re: fclean all

.PHONY: all up down clean fclean re
