#!/bin/bash
for i in emptyfiles_create emptyfiles_delete smallfiles_create smallfiles_rewrite smallfiles_read smallfiles_reread smallfiles_delete largefile_create largefile_rewrite largefile_read largefile_reread largefile_delete directory_crawl_create directory_crawl directory_recrawl metadata_modify directory_crawl_delete;
do echo "$i: $(grep $i $1 | grep -v running | awk '{s+=$2}END{print s/NR}')";
done
