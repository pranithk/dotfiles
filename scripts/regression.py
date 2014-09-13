#!/bin/python

ws="/home/pk1/workspace/gerrit-repo/"
import os
import sys
import urllib
import subprocess
from itertools import izip

TMP_FILE="/tmp/a"

def enumerate_tests (f):
        """ Given a file iterator this function keeps generating the following:
        If the line is a 'test' generate the test number, line.
        Otherwise generate -1, line instead.
        """
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
        """Given a file iterator, list of tests that filed it generates:
        It prints line number, line for each line.
        If the line is a failed test, prepend the line_number with '*'s
        else prepend the line_number with spaces, right justified by
        'justification'
        """
        justification=5
        for line_num, (test_number, line) in enumerate(enumerate_tests(f)):
                fillchar='*' if test_number in fail_tests else ' '
                metadata=str(line_num).rjust(justification, fillchar)
                yield ' '.join ([metadata, line])

def failed_test_lines (f, fail_tests):
        """Given a file iterator, list of tests that filed it generates failed
        tests and prints their line numbers in the file
        """
        for line_num, (test_number, line) in enumerate(enumerate_tests(f)):
                if test_number in fail_tests:
                        yield ' '.join ([str(line_num), line])

def print_test_file (test_file, fail_tests, line_print):
        """Given file_path, fail_tests and the kind of printing lines
        It prints the lines. At the moment files with LOOP tests are not
        supported.
        """
        print test_file, fail_tests
        with open(test_file) as f:
                lines=[line for line in line_print(f, fail_tests)]

        if any("TESTS_EXPECTED_IN_LOOP" in line for line in lines):
                print "Can't pretty print the test file with loops"
                return

        for line in lines:
                print line,

def download_build_console_output (build_url, log_file):
        """Downloads a page given its URL to the path specified"""
        urllib.urlretrieve(build_url, log_file)

def get_link_name(line):
        """Given a <a href...> name </a> extracts 'name'"""
        start = line.find('>')
        end = line.find("</a>", start+1)
        return line[start+1:end]

def get_auth_info (line):
        """Given Author Name <author-mail-id> extracts both.
        Since it is html file it has &lt etc instead of '<'
        """
        ns=line.find(':')+1
        ne=line.find('&')-1
        ms=line.find(';')+1
        me=line.find('>')
        return line[ns:ne], line[ms:me]

def parse_console_output (log_file):
        """Given console logfile pareses varous things into a dictionary."""
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
        """Given Prove's test failure summary, extracts test-file, failures"""
        l=summary.split('\n')
        tests=[x.split()[0] for x in l if '(Wstat' in x]
        failures=[x.split(':')[1].strip() for x in l if 'Failed test' in x]
        return [i for i in izip(tests, failures)]

def get_fail_tests (failures):
        """Given a list of failures with ranges extracts them as individual
        tests. For example, 3-5 becomes 3 4 5 etc
        """
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

def main():
        os.chdir(ws)
        build_url = sys.argv[1]
        download_build_console_output (build_url, TMP_FILE)
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
                        print_test_file (test, fail_tests, add_test_markers);
        os.remove(TMP_FILE)

if __name__ == "__main__":
        main()
