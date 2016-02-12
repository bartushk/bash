#!/bin/bash

#exampel usage: ./vbox-init-windowsserver.sh TestRunner 2048 20480 
hd_ending='.vdi'
hd_dir=~/vbox_hds
hd_loc=$hd_dir/$1$hd_ending
iso_loc=~/isos/en_windows_server_2012_r2_with_update_x64_dvd_6052708.iso
mkdir -p $hd_dir

VBoxManage createvm --name $1 --register

VBoxManage createhd --filename $hd_loc --size $2

VBoxManage modifyvm $1 --ostype Windows2012_64 --memory $3 --acpi on --ioapic on --vram 128 --accelerate3d off --nic1 nat --nictype1 82545EM --cableconnected1 on --audio alsa --audiocontroller ac97

VBoxManage storagectl $1 --name SATA --add sata --controller IntelAhci --bootable on

VBoxManage storagectl $1 --name IDE --add ide --controller PIIX4 --bootable on

VBoxManage storageattach $1 --storagectl SATA --port 0 --device 0 --type hdd --medium $hd_loc

VBoxManage storageattach $1 --storagectl IDE --port 0 --device 0 --type dvddrive --medium $iso_loc


VBoxManage modifyvm $1 --vrde on --vrdeport 3390 --vrdeaddress 0.0.0.0

VBoxManage modifyvm $1 --natpf1 "winrdp,tcp,,3389,,3389"

