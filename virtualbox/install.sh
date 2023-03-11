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

main () {
	printf "partition the disk...\n"
	partition_the_disk > /dev/null
}

main
