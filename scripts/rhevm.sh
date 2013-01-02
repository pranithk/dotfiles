#!/bin/bash
gluster volume set $1 performance.quick-read disable
gluster volume set $1 performance.io-cache disable
gluster volume set $1 performance.stat-prefetch disable
gluster volume set $1 performance.read-ahead disable
gluster volume set $1 cluster.eager-lock enable
gluster volume set $1 storage.linux-aio disable
