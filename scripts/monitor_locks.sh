#!/bin/bash
if [ -z $1]; then
        echo "Provide pid to monitor locks";
        exit 1
fi
while [ 1 ]; do
        sudo kill -USR1 $1 &&
        sudo grep "type=WRITE" /tmp/gfs-repl2_1.$1.dump;
        sleep 1;
        clear;
done;
