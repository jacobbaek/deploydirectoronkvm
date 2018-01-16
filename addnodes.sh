#!/bin/bash

for i in {1,,2}; do virsh -c qemu+ssh://root@192.168.100.1/system domiflist overcloud-node$i | awk '$3 == "provision-net" {print $5};'; done

openstack baremetal import --json ./instackenv.json
openstack baremetal configure boot

for node in $(openstack baremetal node list -c UUID -f value) ; do openstack baremetal node manage $node ; done
openstack overcloud node introspect --all-manageable --provide
