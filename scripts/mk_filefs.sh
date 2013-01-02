dd if=/dev/zero of=$1 bs=1M count=512
mkfs.ext3 $1
mkdir $2
mount -o loop $1 $2
mount | grep "$2"
