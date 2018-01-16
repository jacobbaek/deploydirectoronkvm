#!/bin/bash

openstack baremetal node list -c UUID -f value > /tmp/node_ids.txt

ctl=`sed -n 1p /tmp/node_ids.txt`
com=`sed -n 2p /tmp/node_ids.txt`

openstack baremetal node set --property capabilities='profile:minictl,boot_option:local' $ctl
openstack baremetal node set --property capabilities='profile:minicom,boot_option:local' $com

openstack overcloud profiles list
