#!/bin/bash -x
gluster volume set $1 performance.quick-read off
gluster volume set $1 performance.io-cache off
gluster volume set $1 performance.write-behind off
gluster volume set $1 performance.stat-prefetch off
gluster volume set $1 performance.read-ahead off
gluster volume set $1 performance.open-behind off
