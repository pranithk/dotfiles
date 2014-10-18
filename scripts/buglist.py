#/bin/python
#Usage: python buglist<CR>
#Paste the list of URLs
#Type ctrl+D in the last line twice
import sys
import re

def get_bug_id(line):
        m = re.search('bugzilla.redhat.com/show_bug.cgi\?id=(\d+)', line)
        if m is None:
                return None
        return m.group(1)

def get_bug_list_url(buglist):
        list_url="https://bugzilla.redhat.com/buglist.cgi?quicksearch="
        bug_list=""
        COMMA="%2C"
        SPACE="%20"

        if len(buglist) is 0:
                return None

        for bug in buglist:
                bug_list=bug_list+bug+COMMA+SPACE

        return list_url+bug_list

def get_bug_list():
        buglist=[]
        for line in sys.stdin:
                bug_id = get_bug_id(line)
                if bug_id is not None:
                        buglist.append(bug_id)
        return buglist

def main():
        buglist=get_bug_list()
        print get_bug_list_url(buglist)

if __name__ == "__main__":
        main()
