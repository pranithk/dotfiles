#!/bin/bash -x
#install glusterfs dev-tools
dnf -y install automake autoconf libtool flex bison openssl-devel libxml2-devel python-devel libaio-devel libibverbs-devel librdmacm-devel readline-devel lvm2-devel glib2-devel userspace-rcu-devel libcmocka-devel libacl-devel sqlite-devel fuse-devel redhat-rpm-config
#install awesome vim
dnf -y install vim-X11
#install ruby
dnf -y install ruby

#setup google-chrome 64-bit repo
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

#install google-chrome
dnf -y install google-chrome-stable

#install flash 64-bit
rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
dnf check-update
dnf -y install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl

#install vlc
rpm -ivh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-stable.noarch.rpm
dnf -y install vlc

#install libpng-compat for googletalk
dnf -y install libpng-compat

#install virt-manager
dnf -y install @virtualization
service libvirtd start

#install openssh-server
dnf -y install openssh-server
service sshd start

#install cscope, valgrind
dnf -y install cscope valgrind

#install strace
dnf -y install strace

#irc
dnf -y install pidgin
