#!/bin/bash -x
find /tmp -mtime +10 |xargs rm -f
find /tmp -type d | xargs rmdir
