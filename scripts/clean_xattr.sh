sudo setfattr -x trusted.gfid $1
sudo setfattr -x trusted.glusterfs.volume-id $1
sudo setfattr -x trusted.glusterfs.dht $1
sudo setfattr -x trusted.afr.vol-client-0 $1
sudo setfattr -x trusted.afr.vol-client-1 $1
sudo setfattr -x trusted.afr.vol-trace-0 $1
sudo setfattr -x trusted.afr.vol-trace-1 $1
