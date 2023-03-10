NAME	=	inception-tty

build:
	docker build -t $(NAME) .

test:
	docker run --rm -it -v $(shell pwd):/documents $(NAME)
