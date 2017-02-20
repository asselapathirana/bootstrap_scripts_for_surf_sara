#!/bin/bash
set -e
if [ $# -lt 1 ]
then 
 	echo "USAGE: $0 <mother_machine_ip> (internal: e.g. 10)"
	exit 1
fi 
ip=${1}
#scp -o "StrictHostKeyChecking no" ubuntu@$ip:/ 
cat /etc/fstab |awk '{if($3 !="nfs"){ print $0}}' > tmp.file
cp tmp.file /etc/fstab
cat << EOF >> /etc/fstab
$ip:/opt /opt nfs defaults 0 0 
$ip:/data /data nfs defaults 0 0 
EOF
if [ ! -d "/opt" ] ; then mkdir /opt ; fi 
if [ ! -d "/data" ] ; then mkdir /data ; fi

apt install nfs-common 
mount -a
cp /opt/tools/authorized_keys ~ubuntu/.ssh/.
chmod og-rwx ~ubuntu/.ssh/authorized_keys
apt-get install libboost-all-dev
. /opt/src/setintel
