NAME	=	inception-wordpress

build:
	docker build -t $(NAME) .

test:
	docker run -d --rm --network incepnet --name inception-container-wordpress $(NAME)
