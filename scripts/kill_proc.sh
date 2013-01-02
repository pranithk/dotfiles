sudo kill -9 `pgrep gluster`
cd /var/lib/glusterd && sudo rm -rf * && cd -
sudo rm -f /usr/local/var/log/glusterfs/{,bricks/}*log
sudo rm -rf /tmp/0 /tmp/1 /tmp/2 /tmp/3 /tmp/4 /tmp/5 /tmp/6
sudo rm -rf /tmp/brick1 /tmp/brick2 /tmp/brick3 /tmp/brick4 /tmp/brick5
sudo rm -rf /tmp/nogfid1 /tmp/nogfid2
sudo rm -rf /gfs/*
for m in `mount | grep fuse.glusterfs | awk '{print $3}'`; do
        umount $m
done
