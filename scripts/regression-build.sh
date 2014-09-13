#/bin/bash -x
H0="192.168.122.24"
F0="glusterfs-3.6.0.25.tar.gz"
rm -f "$F0"
rm -rf ~/rpmbuild
sudo make distclean;
./autogen.sh && sudo ./configure --enable-fusermount && sudo make CFLAGS="-DDEBUG -g3 " install 1>/dev/null && make dist && rm -rf ~/rpmbuild && rpmbuild -ta "$F0" && ssh root@$H0 "rm -rf /root/x86_64 && rpm -qa | grep gluster| xargs rpm -e; bash -x /root/dotfiles/scripts/kill_proc.sh" && scp -r ~/rpmbuild/RPMS/x86_64/ root@$H0: && ssh root@$H0 "rpm -ivh /root/x86_64/*rpm && sed -i '/H0=\${H0:=\`hostname --fqdn\`};/c\H0=192.168.122.24;' /usr/share/glusterfs/tests/include.rc"
