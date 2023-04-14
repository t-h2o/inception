include srcs/.env

HOSTSFILE	=	/etc/hosts
HOSTALIAS	=	127.0.0.1 $(DOMAIN_NAME)

ps:
	@docker ps

up:
	docker compose -f srcs/docker-compose.yaml up --detach --build

down:
	docker compose -f srcs/docker-compose.yaml down

re: down up

hostname:
	grep "$(HOSTALIAS)" "$(HOSTSFILE)" || echo "$(HOSTALIAS)" >> "$(HOSTSFILE)"
