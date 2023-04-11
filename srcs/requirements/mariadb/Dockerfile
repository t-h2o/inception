FROM archlinux:latest

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm mariadb

# place the entrypoint script
RUN mkdir /script
COPY entrypoint.sh /script/
RUN chmod +x /script/entrypoint.sh

# launch a shell
ENTRYPOINT ["/script/entrypoint.sh"]
