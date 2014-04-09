#!/bin/bash
grep -h "\[.*usage-type.*\]" $1 $2 | sort | uniq |
while read usage_type;
do
#until I figure out how sed processes special characters, remove them
#delete till leading '/'
usage_type=${usage_type/\[*\//\[}
#delete '[', ']'
usage_type=${usage_type:1:-1}
#get matching sections for the usage-type
val1=$(eval "sed -e '/./{H;$!d;}' -e 'x;/$usage_type/!d;' $1")
val2=$(eval "sed -e '/./{H;$!d;}' -e 'x;/$usage_type/!d;' $2")

#see if the num_allocs are increasing
num_allocs1=$(echo "$val1" | grep "^num_allocs" | cut -d'=' -f2)
num_allocs2=$(echo "$val2" | grep "^num_allocs" | cut -d'=' -f2)
if [ -z $num_allocs1 ];
then
        num_allocs1=0
fi

if [ -z $num_allocs2 ];
then
        num_allocs2=0
fi

if [ $num_allocs1 -lt $num_allocs2 ];
then
        echo -e "\n"
        echo "$val1"
        echo ------------------------------------------------------------------
        echo "$val2"
fi
done
