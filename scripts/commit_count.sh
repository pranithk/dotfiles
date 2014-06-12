#/bin/bash
git log --author="$1" --format=format:%cd --date=short | cut -f1,2 -d'-' | sort -r | uniq -c | less
