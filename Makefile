NAME = inception

all:
	docker compose -f srcs/docker-compose.yml up --build

up:
	docker compose -f srcs/docker-compose.yml up

down:
	docker compose -f srcs/docker-compose.yml down

.PHONY: all up down
