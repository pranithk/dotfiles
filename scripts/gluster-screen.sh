#!/bin/bash

screen -d -m -S test
SESSION=`screen -list | grep test | awk '{print $1}'`

screen -X -S $SESSION screen -t test 1
screen -X -S $SESSION screen -t etc-glusterd 2
screen -X -S $SESSION screen -t vim 3
screen -X -S $SESSION -p 0 title output
screen -S $SESSION -p 0 -X stuff "sudo su -
"
screen -S $SESSION -p 1 -X stuff "vim ~/workspace/tests/afr/afr.py
"
screen -S $SESSION -p 2 -X stuff "cd /etc/glusterd && sudo glusterd --debug
"
screen -S $SESSION -p 3 -X stuff  "cd ~/workspace/afr-repo
"
screen -x $SESSION -p 0
