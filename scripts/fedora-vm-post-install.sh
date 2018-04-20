#!/bin/bash -x
#install glusterfs dev-tools
dnf -y install automake autoconf libtool flex bison openssl-devel libxml2-devel python-devel libaio-devel libibverbs-devel librdmacm-devel readline-devel lvm2-devel glib2-devel userspace-rcu-devel libcmocka-devel libacl-devel sqlite-devel fuse-devel redhat-rpm-config
#install awesome vim
dnf -y install vim-X11
#install ruby
dnf -y install ruby

#install openssh-server
dnf -y install openssh-server
systemctl start sshd
systemctl enable sshd

#install cscope, valgrind
dnf -y install cscope valgrind

#install strace
dnf -y install strace
