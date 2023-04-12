NAME	=	inception-wordpress

build:
	docker build -t $(NAME) .

test:
	docker run -d --rm --network incepnet --name philippe $(NAME)
