#!/bin/bash
cd /etc/sysconfig/network-scripts/
array=(ifcfg-enp131s0 ifcfg-enp137s0 ifcfg-enp132s0 ifcfg-enp138s0 ifcfg-enp133s0 ifcfg-enp139s0)
echo "********************Begin Backup******************"
for NetName in ${array[@]}
do
  echo "Backing up $NetName ......"
  cp -arf "$NetName" "$NetName".bak 
  sed -i '/PROXY_METHOD/d' $NetName
  sed -i '/BROWSER_ONLY/d' $NetName
  sed -i '/BOOTPROTO/d' $NetName
  sed -i '/DEFROUTE/d' $NetName
  sed -i '/IPV4_FAILURE_FATAL/d' $NetName
  sed -i '/IPV6INIT/d' $NetName
  sed -i '/IPV6_AUTOCONF/d' $NetName
  sed -i '/IPV6_DEFROUTE/d' $NetName
  sed -i '/IPV6_FAILURE_FATAL/d' $NetName
  sed -i '/IPV6_ADDR_GEN_MODE/d' $NetName
  sed -i '/ONBOOT/d' $NetName
  echo "BOOTPROTO=none" >>$NetName
  echo "ONBOOT=yes" >>$NetName
  case $NetName in 
       ifcfg-enp131s0|ifcfg-enp137s0)
       echo "MASTER=bond0" >>$NetName
       ;;
       ifcfg-enp132s0|ifcfg-enp138s0)
       echo "MASTER=bond1" >>$NetName
       ;;
       ifcfg-enp133s0|ifcfg-enp139s0)
       echo "MASTER=bond2" >>$NetName
       ;;
  esac
  echo "SLAVE=yes" >>$NetName
done
echo "********************End Backup******************"

echo "******************Begin Create Network Bond ******************"
array1=(ifcfg-bond0 ifcfg-bond1 ifcfg-bond2)
for bondName in ${array1[@]}
do
   echo "Creating $bondName ......"
   case $bondName in 
       ifcfg-bond0)
       echo "DEVICE=bond0" >>$bondName
       echo "NAME=bond0" >>$bondName
       echo "BONDING_OPTS=\"mode=1 miimon=100\"" >>$bondName
       echo "IPADDR="$1"" >>$bondName
       ;;
       ifcfg-bond1)
       echo "DEVICE=bond1" >>$bondName
       echo "NAME=bond1" >>$bondName
       echo "BONDING_OPTS=\"mode=4 miimon=100\"" >>$bondName
       echo "IPADDR="$2"" >>$bondName
       echo "GATEWAY="$3"" >>$bondName
       ;;
       ifcfg-bond2)
       echo "DEVICE=bond2" >>$bondName
       echo "NAME=bond2" >>$bondName
       echo "BONDING_OPTS=\"mode=4 miimon=100\"" >>$bondName
       echo "IPADDR="$4"" >>$bondName
       ;;
  esac
  echo "TYPE=bond" >>$bondName
  echo "BOOTPROTO=static" >>$bondName
  echo "BONDING_MASTER=yes" >>$bondName
  echo "ONBOOT=yes" >>$bondName    
  echo "NETMASK=255.255.255.0" >>$bondName   
done
echo "******************End Create Network Bond ******************"

echo "*****************Begin Restart Network******************"
systemctl restart network
service network restart

if ping -c 2 10.178.128.187 >/dev/null; then
  echo "Good boy!Ping is successful."
else
  echo "Oh Shit!!!! Ping is failure."
fi



