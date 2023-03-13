#!/bin/sh

partition_the_disk () {
	# overwrite the disk
	# create two partitions
	# 1 swap
	# 2 linux filesystem
	gdisk /dev/sda << eof
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
	pac="$pac btrfs-progs"
	pac="$pac e2fsprogs"
	pac="$pac lvm2"
	pac="$pac cryptsetup"

	pac="$pac grub"

	pac="$pac networkmanager"

	pac="$pac git"
	pac="$pac vim"
	pac="$pac bat"
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
	myuser="user"
	mypw="1234"

	arch-chroot /mnt << eof
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
eof
}

bootloader () {
	arch-chroot /mnt << eof
grub-install --force --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
eof
}

enable_services () {
	arch-chroot /mnt << eof
systemctl enable NetworkManager
pacman -S --noconfirm openssh
systemctl enable sshd
eof
}

main () {
	printf "partition the disk...\n"
	partition_the_disk > /dev/null

	printf "format the partitions...\n"
	format_the_partitions > /dev/null

	printf "mount the file systems...\n"
	mount_the_file_systems > /dev/null

	printf "install essential packages...\n"
	install_essential_packages > /dev/null

	printf "fstab...\n"
	fstab > /dev/null

	printf "chroot...\n"
	chroot > /dev/null

	printf "set the bootloader...\n"
	bootloader > /dev/null

	printf "enable services...\n"
	enable_services > /dev/null

	printf "shutdown and reboot without the iso file.\n"
}

main
