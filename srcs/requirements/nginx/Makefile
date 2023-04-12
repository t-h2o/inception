NAME	=	inception-nginx

build:
	docker build -t $(NAME) .

test:
	docker run --rm -d -p 80:80 --name nemo $(NAME)
	docker exec -it nemo ip a

stop:
	docker stop nemo
