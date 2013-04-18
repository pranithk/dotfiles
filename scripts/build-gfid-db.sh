#!/bin/bash
find $1 -path $1/.glusterfs -prune  -o -print| while read fpath; do gfid=$(getfattr -n trusted.gfid -ehex $fpath|grep trusted.gfid|cut -f2 -d'='); echo "$fpath => $gfid"; done
