#!/bin/bash
echo "Files" $1 $2 "%-difference"| awk '{printf "%-25s %-20s %-20s %-20s\n", $1, $2, $3, $4}'
for i in emptyfiles_create emptyfiles_delete smallfiles_create smallfiles_rewrite smallfiles_read smallfiles_reread smallfiles_delete largefile_create largefile_rewrite largefile_read largefile_reread largefile_delete directory_crawl_create directory_crawl directory_recrawl metadata_modify directory_crawl_delete;
do
        val1=$(grep -w $i $1|awk '{print $2}');
        val2=$(grep -w $i $2|awk '{print $2}');
        perc=$(bc <<< "scale=4;($val2 - $val1)/$val1 * 100")
        echo $i $val1 $val2 $perc | awk '{printf "%-25s %-20s %-20s %-20s\n", $1, $2, $3, $4}'
done
