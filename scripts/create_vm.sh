#!/bin/bash

# vboxmanage manual
# https://www.virtualbox.org/manual/ch08.html

# remove from the list
# VBoxManage list vms
# VBoxManage unregistervm <ID>|<NAME>

VM_PATH="${HOME}/goinfre/my_vm_created_by_cli"
VM_NAME="vmCreatedByCLI"
VDI_FILE="${VM_PATH}/Archlinux_64.vdi"
ARCHISO_FILE="${VM_PATH}/archlinux_bootable.iso"
ARCHISO_VERSION="$(date +"%Y.%m.01")"

create_vm () {
	VBoxManage createvm --name "${VM_NAME}" --basefolder="${VM_PATH}" --ostype Archlinux_64 --register
	VBoxManage modifyvm "${VM_NAME}" --nic1 bridged --bridgeadapter1 eth0 --memory=1024 --vram=16 --pae=off --rtcuseutc=on
}

create_vdi () {
	# For list hdds: vboxmanage list hdds
	# For delete vdi: vboxmanage closemedium disk eaf35acc-b45b-4b8f-80f0-6877b8621311 --delete
	VBoxManage createhd --format VDI --size 16384 --variant Fixed --filename "${VDI_FILE}"
}

create_vm_sata () {
	VBoxManage storagectl "${VM_NAME}" --name "SATA Controller" --add sata --bootable on
	VBoxManage storageattach "${VM_NAME}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "${VDI_FILE}"
}

download_archlinux_iso () {
	if [ -f "${ARCHISO_FILE}" ]; then
		echo "${ARCHISO_FILE} already exists"
	else
		curl https://theswissbay.ch/archlinux/iso/"${ARCHISO_VERSION}"/archlinux-x86_64.iso --output "${ARCHISO_FILE}"
	fi
}

attach_archlinux_iso () {
	VBoxManage storagectl "${VM_NAME}" --name "IDE Controller" --add ide
	VBoxManage storageattach "${VM_NAME}" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "${ARCHISO_FILE}"
}

remove_archlinux_iso () {
	VBoxManage storageattach "${VM_NAME}" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium none
}

start_vm () {
	# headless means, without graphic interface
	VBoxManage startvm "${VM_NAME}" # --type headless
}

# $1: step name
step_menu () {
	echo "$1"
	printf "jump [y/N/exit]: "; read -r answer
	if [ "${answer}" == "" ]; then
		echo "continue"
		return 0
	elif [ "${answer}" == "n" ]; then
		echo "continue"
		return 0
	elif [ "${answer}" == "y" ]; then
		echo "jump"
		return 1
	elif [ "${answer}" == "exit" ]; then
		echo "exit"
		exit 0
	fi
}

setup_the_vm () {
	# generate the folder
	mkdir -p "${VM_PATH}"

	step_menu "create the vm"

	# create the vm
	if [ $? -eq 0 ]; then
		create_vm
	fi

	step_menu "download_archlinux_iso"

	# download GNU/Linux iso
	if [ $? -eq 0 ]; then
		download_archlinux_iso
	fi

	step_menu "attach_archlinux_iso"

	# set a bootable image
	if [ $? -eq 0 ]; then
		attach_archlinux_iso
	fi

	step_menu "create_vdi"

	# create a vdi
	if [ $? -eq 0 ]; then
		create_vdi
	fi

	step_menu "create_vm_sata"

	# create a sata
	if [ $? -eq 0 ]; then
		create_vm_sata
	fi

	step_menu "start_vm"

	if [ $? -eq 0 ]; then
		start_vm
	fi

}

main_menu () {
	printf "main menu:\n1: setup the vm\n2: list vms\n3: exit\n4: start the vm\n5: generate info-vm.txt\n6: remove archlinux iso\n7: delete the vm\n[1-7]: "; read -r answer
	if [ "${answer}" == "1" ]; then
		return 1
	elif [ "${answer}" == "2" ]; then
		return 2
	elif [ "${answer}" == "3" ]; then
		return 3
	elif [ "${answer}" == "4" ]; then
		return 4
	elif [ "${answer}" == "5" ]; then
		return 5
	elif [ "${answer}" == "6" ]; then
		return 6
	elif [ "${answer}" == "7" ]; then
		return 7
	else
		printf "\ntry again\n\n"
		main_menu
	fi
}

main () {
	main_menu

	main_answer=$?
	if [ ${main_answer} -eq 1 ]; then
		setup_the_vm
	elif [ ${main_answer} -eq 2 ]; then
		VBoxManage list vms
	elif [ ${main_answer} -eq 3 ]; then
		exit 0
	elif [ ${main_answer} -eq 4 ]; then
		start_vm
	elif [ ${main_answer} -eq 5 ]; then
		VBoxManage showvminfo ${VM_NAME} > info-vm.txt
	elif [ ${main_answer} -eq 6 ]; then
		remove_archlinux_iso
	elif [ ${main_answer} -eq 7 ]; then
		VBoxManage unregistervm --delete ${VM_NAME}
	fi

	main
}

main
