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

main () {
	printf "partition the disk...\n"
	partition_the_disk > /dev/null

	printf "format the partitions...\n"
	format_the_partitions > /dev/null
}

main
