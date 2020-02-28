#!/bin/bash

cd /etc/sysconfig/network-scripts/
array=(ifcfg-enp131s0 ifcfg-enp137s0 ifcfg-enp132s0 ifcfg-enp138s0 ifcfg-enp133s0 ifcfg-enp139s0)
for NetName in ${array[@]}
do
  cp -arf "$NetName".bak  "$NetName"
done

rm -rf ifcfg-Bond0
rm -rf ifcfg-bond1
rm -rf ifcfg-bond2

systemctl restart network



