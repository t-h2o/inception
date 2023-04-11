NAME	=	inception-arch

build:
	docker build -t $(NAME) .

test:
	docker run --rm -it --expose 3306 --name "archLinux" $(NAME)
