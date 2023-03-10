NAME	=	inception-base

build:
	docker build -t $(NAME) .

test:
	docker run --rm -v $(shell pwd):/documents $(NAME)
