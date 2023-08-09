include srcs/.env

HOSTSFILE	=	/etc/hosts
HOSTALIAS	=	127.0.0.1 $(DOMAIN_NAME)

ADOC    =       asciidoctor --require=asciidoctor-diagram
DOCU    =       docs/README.adoc
INDEX   =       docs/index.html

ps:
	@docker ps

up:
	mkdir -p /home/$(shell whoami)/data/wordpress
	mkdir -p /home/$(shell whoami)/data/mysql
	docker compose -f srcs/docker-compose.yaml up --build

build:
	docker compose -f srcs/docker-compose.yaml build

down:
	docker compose -f srcs/docker-compose.yaml down

clean-image:
	docker image rm ${IMAGE_NGINX} || true
	docker image rm ${IMAGE_WORDPRESS} || true
	docker image rm ${IMAGE_MARIADB} || true

clean-volume:
	docker volume rm basedata || true
	docker volume rm website || true

re: down up

hostname:
	grep "$(HOSTALIAS)" "$(HOSTSFILE)" || echo "$(HOSTALIAS)" >> "$(HOSTSFILE)"

doc:
	@printf "$(YELLOW)Generating documentations..$(DEFAULT)\n"
	@$(ADOC) $(DOCU) -o $(INDEX)

docdocker:
	@printf "$(YELLOW)launch the asciidoctor/docker-asciidoctor docker image..$(DEFAULT)\n"
	@docker run --rm -v $(shell pwd):/documents/ asciidoctor/docker-asciidoctor make doc

base:
	@make -C $(DBASE)
	@docker run --rm $(NBASE)
