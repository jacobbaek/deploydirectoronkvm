virt-install  --name=undercloud  --ram=6128  --vcpus=4  --cdrom= --os-type=linux --os-variant=rhel7 --network bridge=br0 --graphics=spice --disk path=/var/lib/libvirt/images/undercloud.dsk,size=60
