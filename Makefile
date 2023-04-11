ps:
	@docker ps

up:
	docker compose -f srcs/docker-compose.yaml up --detach

down:
	docker compose -f srcs/docker-compose.yaml down
