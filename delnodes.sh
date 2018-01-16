#!/bin/bash


for i in $(openstack baremetal node list -f value -c UUID); do openstack baremetal node delete $i ;done
