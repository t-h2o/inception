NAME	=	inception-ssh

build:
	docker build -t $(NAME) .

test:
	docker run --name "paul" --rm -v $(shell pwd):/documents $(NAME)
