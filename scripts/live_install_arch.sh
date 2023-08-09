#!/bin/sh

partition_the_disk () {
	# overwrite the disk
	# create two partitions
	# 1 swap
	# 2 linux filesystem
	gdisk /dev/sda <<- eof
	o
	y
	n


	+1GiB
	8200
	p
	n



	8300
	p
	w
	y
	eof
}

format_the_partitions () {
	mkswap -L THE_SWAP /dev/sda1
	mkfs.ext4 -L THE_ROOT /dev/sda2
}

mount_the_file_systems () {
	swapon /dev/sda1
	mount /dev/sda2 /mnt
}

install_essential_packages () {
	pac="base"
	pac="$pac base-devel"
	pac="$pac linux-zen"
	pac="$pac linux-firmware"

	pac="$pac dosfstools"
	pac="$pac e2fsprogs"

	pac="$pac grub"

	pac="$pac networkmanager"

	pac="$pac git"
	pac="$pac vim"
	pac="$pac zsh"
	pac="$pac tmux"
	pac="$pac tree"
	pac="$pac kitty"
	pac="$pac neofetch"

	pac="$pac man-db"
	pac="$pac man-pages"

	pacstrap /mnt $pac
}

fstab () {
	genfstab -U /mnt >> /mnt/etc/fstab
}

chroot () {
	region="Europe"
	city="Zurich"

	myhostame="panic"
	mypw="1234"

	arch-chroot /mnt <<- eof
	ln -sf /usr/share/zoneinfo/$region/$city /etc/localtime
	hwclock --systohc

	echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
	locale-gen
	echo "LANG=en_US.UTF-8" > /etc/locale.conf

	echo $myhostame > /etc/hostname

	groupadd wheel
	useradd -m $myuser
	usermod -aG wheel $myuser

	yes $mypw | passwd
	yes $mypw | passwd $myuser

	EDITOR="sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/  %wheel ALL=(ALL:ALL) NOPASSWD: ALL/'" visudo
	eof
}

bootloader () {
	arch-chroot /mnt <<- eof
	grub-install --force --target=i386-pc /dev/sda
	grub-mkconfig -o /boot/grub/grub.cfg
	eof
}

enable_services () {
	arch-chroot /mnt <<- eof
	pacman -S --noconfirm openssh docker docker-compose ansible
	systemctl enable sshd
	systemctl enable docker
	systemctl enable NetworkManager
	usermod -aG docker ${myuser}
	su ${myuser}
	cd
	git clone https://github.com/t-h2o/inception
	git clone https://github.com/t-h2o/ansible-my-conf
	ssh-keygen -t ed25519 -f /home/${myuser}/.ssh/id_ed25519 -P ""
	cat /etc/ssh/ssh_host_ed25519_key.pub >> /home/${myuser}/.ssh/known_hosts
	cat /home/${myuser}/.ssh/id_ed25519.pub >> /home/${myuser}/.ssh/authorized_keys
	exit
	eof
}

ask_user_name () {
	printf "username: "
	read myuser

	if [ "$(echo ${myuser} | wc -w)" -ne 1 ]; then
		printf "not valid username\n"
		ask_user_name
	fi
}

main () {
	ask_user_name

	printf "partition the disk...\n"
	partition_the_disk

	printf "format the partitions...\n"
	format_the_partitions

	printf "mount the file systems...\n"
	mount_the_file_systems

	printf "install essential packages...\n"
	install_essential_packages

	printf "fstab...\n"
	fstab

	printf "chroot...\n"
	chroot

	printf "set the bootloader...\n"
	bootloader

	printf "enable services...\n"
	enable_services

	printf "shutdown and reboot without the iso file.\n"
}

main
