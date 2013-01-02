file="abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz"
for i in `seq 1 $1`
do
	for j in `seq 1 $2`
	do
		dd if=/dev/urandom of="$file$j" bs=128K count=10 2>/dev/null 1>/dev/null
	done
	mkdir dir$i && cd dir$i
done

