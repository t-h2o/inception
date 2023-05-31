include srcs/.env

HOSTSFILE	=	/etc/hosts
HOSTALIAS	=	127.0.0.1 $(DOMAIN_NAME)

ADOC    =       asciidoctor --require=asciidoctor-diagram
DOCU    =       docs/README.adoc
INDEX   =       docs/index.html

ps:
	@docker ps

up:
	docker compose -f srcs/docker-compose.yaml up --detach --build

down:
	docker compose -f srcs/docker-compose.yaml down

clean-image:
	docker image rm inception-image-mariadb
	docker image rm inception-image-wordpress
	docker image rm inception-image-nginx

clean-volume:
	docker volume rm basedata
	docker volume rm website

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
