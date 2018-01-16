#!/bin/bash

openstack stack delete $(openstack stack list -c ID -f value)
