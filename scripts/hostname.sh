if [ -z $1 ]; then echo "Provide hostname"; exit 1; fi
sed "s/HOSTNAME=.*/HOSTNAME=$1/g" /etc/sysconfig/network
sysctl kernel.hostname=$1
