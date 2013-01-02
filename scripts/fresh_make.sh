#!/bin/bash -x
if [ -d ".git" ]; then
sudo make distclean ; ./autogen.sh && sudo ./configure && sudo make CFLAGS="-DDEBUG -g3" install -j 32 1>/dev/null
else
        echo "Not build Directory"
fi
