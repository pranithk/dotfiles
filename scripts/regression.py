#!/bin/python

ws="/home/pk1/workspace/gerrit-repo/"
import os
import sys
import urllib
import subprocess
from itertools import izip

TMP_FILE="/tmp/a"

def enumerate_tests (f):
        test_words=["TEST", "EXPECT", "EXPECT_NOT", "EXPECT_WITHIN", "EXPECT_KEYWORD"]
        test_number=0
        for line in f:
                first_word=line.split(' ', 1)[0]
                if first_word in test_words:
                        test_number = test_number+1
                        yield test_number, line
                else:
                        yield -1, line

def add_test_markers (f, fail_tests):
        justification=5
        for line_num, (test_number, line) in enumerate(enumerate_tests(f)):
                fillchar='*' if test_number in fail_tests else ' '
                metadata=str(line_num).rjust(justification, fillchar)
                yield ' '.join ([metadata, line])

def print_test_file (test, fail_tests):
        print test, fail_tests
        with open(test) as f:
                lines=[line for line in add_test_markers(f, fail_tests)]

        if any("TESTS_EXPECTED_IN_LOOP" in line for line in lines):
                print "Can't pretty print the test file with loops"
                return

        for line in lines:
                print line,

def download_build_console_output (build_id, log_file):
        url="http://build.gluster.org/job/regression/"+str(build_id)+"/consoleFull"
        urllib.urlretrieve(url, log_file)

def get_link_name(line):
        start = line.find('>')
        end = line.find("</a>", start+1)
        return line[start+1:end]

def get_auth_info (line):
        ns=line.find(':')+1
        ne=line.find('&')-1
        ms=line.find(';')+1
        me=line.find('>')
        return line[ns:ne], line[ms:me]

def parse_console_output (log_file):
        info={}
        with open(log_file) as f:
                for line in f:
#Check if it is user info
                        pos=line.find("Started by user")
                        if pos != -1:
                                info['build-triggered-by']=get_link_name(line[pos:-1])
                                continue
#Check if it is build-url info
                        if "+ BURL" in line:
                                info['build-url']=get_link_name(line)
                                continue
#Check if it is change-id info
                        if "+ REF=refs/changes/" in line:
                                l=line.split('/')
                                info['change-id']=l[3]
                                info['rev']=l[4].strip('\n')
                                continue
#Check if it is Author info
                        if "Author: " in line:
                                info['author-name'], info['author-mail'] = get_auth_info (line)
                                continue
#Check if it is logs info
                        if "Logs archived in " in line:
                                pos=line.find('/')
                                pos=line.find('/', pos+1)
                                info['log-url']="http://build.gluster.org:443"+line[pos:-1]
                                continue
#Check for tests that failed:
                        if "Test Summary Report" in line:
                                while True:
                                        info['summary']=info.get('summary', '')+line
                                        line=next(f)
                                        pos=line.find("Result: FAIL")
                                        if pos != -1:
                                                break
        return info

def parse_failures (summary):
        l=summary.split('\n')
        tests=[x.split()[0] for x in l if '(Wstat' in x]
        failures=[x.split(':')[1].strip() for x in l if 'Failed test' in x]
        return [i for i in izip(tests, failures)]

def get_fail_tests (failures):
        tests=[]
        ranges=failures.split(',')
        for r in ranges:
                nums=r.split('-')
                tests.extend(range(int(nums[0]), int(nums[-1])+1))
        return tests

def format_print (key, val):
        print "%-25s ==> %s" % (key, val)

def print_build_info (info, test_author):
        format_print("Patch", "http://review.gluster.com/#/c/"+info['change-id']+'/'+info['rev'])
        format_print("Author", info['author-name']+' '+info['author-mail'])
        format_print("Build triggered by", info['build-triggered-by'])
        format_print("Build-url", info['build-url'])
        format_print("Download-log-at", info['log-url'])
        format_print("Test written by", test_author)

os.chdir(ws)
build_id = sys.argv[1]
download_build_console_output (build_id, TMP_FILE)
info=parse_console_output (TMP_FILE)
if 'summary' in info:
        failures = parse_failures (info['summary'])
        for test, failure in failures:
                if not os.path.isfile (test):
                        print test + " file not in repo"
                        continue
                test_author=subprocess.check_output('git log '+test+' | grep -e "^\s*Author:" | tail -1', shell=True)
                fail_tests=get_fail_tests (failure)
                print_build_info (info, test_author)
                print_test_file (test, fail_tests);
os.remove(TMP_FILE)
