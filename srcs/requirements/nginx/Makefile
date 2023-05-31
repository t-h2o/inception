NAME	=	inception-nginx

build:
	docker build -t $(NAME) .

test:
	docker run --rm -d -p 80:80 --name inception-container-nginx $(NAME)
	docker exec -it inception-container-nginx ip a

stop:
	docker stop inception-container-nginx
