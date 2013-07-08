#!/bin/bash -x
#install glusterfs dev-tools
yum -y install git libtool autoconf automake flex bison openssl openssl-devel libibverbs-devel readline-devel libxml-devel libaio-devel libxml2-devel
#install awesome vim
yum -y install vim-X11
#install ruby
yum -y install ruby

#setup google-chrome 64-bit repo
cat >/etc/yum.repos.d/google.repo <<EOF
[google-chrome]
name=google-chrome - 64-bit
baseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

#install google-chrome
yum -y install google-chrome-stable

#install flash 64-bit
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
yum check-update
yum -y install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl

#install vlc
rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
yum -y install vlc

#install libpng-compat for googletalk
yum -y install libpng-compat

#install virt-manager
yum -y install @virtualization
service libvirtd start

#install openssh-server
yum -y install openssh-server
service sshd start

#install cscope, valgrind
yum -y install cscope valgrind

#install strace
yum -y install strace

#irc
yum -y install pidgin
