#!/bin/bash
strace_file_prefix=$1

#get the number of disk syscalls in syscalls.txt:
cut -f1 -d'('  $strace_file_prefix*| sort | uniq -c > syscalls.txt
for i in clone close epoll_ctl epoll_wait futex getegid geteuid getgroups madvise mmap mprotect munmap nanosleep restart_syscall rt_sigaction rt_sigprocmask rt_sigtimedwait select set_robust_list; do sed -i "/$i/d" syscalls.txt; done

#gather per syscall latencies in $i-latency.txt
for i in `awk '{print $2}' syscalls.txt`; do grep -w $i $strace_file_prefix* > $i-latency.txt; done

#Per fop last 10 maximum latency:
for i in `awk '{print $2}' syscalls.txt`; do echo $i; awk '{print $NF}' $i-latency.txt | cut -f2 -d '<' | cut -f1 -d '>' | sort -n | tail -10; done > per-fop-latency.txt
