NAME = inception

all:
	docker compose -f srcs/docker-compose.yml up --build

.PHONY: all
