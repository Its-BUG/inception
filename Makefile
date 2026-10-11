NAME = inception
COMPOSE = docker compose -f srcs/docker-compose.yml

all: up

up:
	$(COMPOSE) up --build -d

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	docker system prune -af

re: fclean up

.PHONY: all up down clean fclean re

