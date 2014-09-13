#!/bin/bash
if [ "$#" -ne 2 ];
then
        echo "Usage: $0 <gluster-tar-file-name> <file-with-hosts>";
        exit 0;
fi
tgz_name=$1
gluster_tar=${1%.*}
gluster_dir=${gluster_tar%.*}
hostsfile=$2
rm -f $tgz_name
make distclean
./autogen.sh && ./configure --enable-fusermount && make CFLAGS="-g3 -DDEBUG" install -j 32 1>/dev/null && make dist
if [ ! -f $tgz_name ];
then
        exit "Tar file specified $tgz_name is not present"
fi

for host in `cat $hostsfile`
do
        scp $tgz_name root@$host:
        echo "tar xzf $tgz_name && cd $gluster_dir && find . | xargs touch && ./autogen.sh && ./configure --enable-fusermount && make CFLAGS=\"-DDEBUG -g3 -O0\" install -j 32 1>/dev/null" | ssh root@$host bash -xs  &
done
wait

