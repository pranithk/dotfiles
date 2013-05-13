#!/bin/bash
rm -rf $gluster_dir
tar xf $1 || exit 1
gluster_tar=${1%.*}
gluster_dir=${gluster_tar%.*}

cd $gluster_dir
find . | xargs touch && ./autogen.sh && ./configure --enable-fusermount && make CFLAGS="-DDEBUG -g3" install -j 32 1>/dev/null
