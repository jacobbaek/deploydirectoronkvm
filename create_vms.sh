#!/bin/bash

## variables 
_path='/var/lib/libvirt/images/'
ctl='overcloud-controller'
com1='overcloud-compute1'
com2='overcloud-compute2'

ctl_path=${_path}${ctl}'.qcow2'
com1_path=${_path}${com1}'.qcow2'
com2_path=${_path}${com2}'.qcow2'
tmp_path='/tmp/'

# delete existed environment
sudo virsh undefine --domain $ctl
sudo virsh undefine --domain $com1
sudo virsh undefine --domain $com2
sudo rm -rf ${_path}overcloud-*

# make a new environment
sudo qemu-img create -f qcow2 -o preallocation=metadata $tmp_path$ctl'.qcow2' 60G
sudo qemu-img create -f qcow2 -o preallocation=metadata $tmp_path$com1'.qcow2' 60G
sudo qemu-img create -f qcow2 -o preallocation=metadata $tmp_path$com2'.qcow2' 60G
sudo chown qemu:qemu ${tmp_path}overcloud-*
sudo mv ${tmp_path}overcloud-* ${_path}

sudo virt-install --memory 8192 --vcpus 2 --os-variant rhel7 --disk path=$ctl_path,device=disk,bus=virtio,format=qcow2 --noautoconsole --vnc --name $ctl --cpu Haswell,+vmx --dry-run --print-xml > /tmp/$ctl.xml
sudo virt-install --memory 8192 --vcpus 2 --os-variant rhel7 --disk path=$com1_path,device=disk,bus=virtio,format=qcow2 --noautoconsole --vnc --name $com1 --cpu Haswell,+vmx --dry-run --print-xml > /tmp/$com1.xml
sudo virt-install --memory 8192 --vcpus 2 --os-variant rhel7 --disk path=$com2_path,device=disk,bus=virtio,format=qcow2 --noautoconsole --vnc --name $com2 --cpu Haswell,+vmx --dry-run --print-xml > /tmp/$com2.xml

sudo virsh define --file /tmp/$ctl.xml
sudo virsh define --file /tmp/$com1.xml
sudo virsh define --file /tmp/$com2.xml

sudo yum install -y python-virtualbmc

#ssh-keygen -b 2048 -t rsa -f /home/stack/.ssh/id_rsa -q -N ""
KEY=`cat /home/stack/.ssh/id_rsa.pub`
sudo sed -i "$ a $KEY" /root/.ssh/authorized_keys

vbmc add $ctl --port 6001 --username admin --password password --libvirt-uri qemu+ssh://root@192.168.122.1/system
vbmc add $com1 --port 6001 --username admin --password password --libvirt-uri qemu+ssh://root@192.168.122.1/system
vbmc add $com2 --port 6001 --username admin --password password --libvirt-uri qemu+ssh://root@192.168.122.1/system

vbmc start $ctl
vbmc start $com1
vbmc start $com2
