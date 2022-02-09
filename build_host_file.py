#!/usr/bin/python
import sys
import ast


hosts_ip = sys.argv[1]  # input file with ec2 public ip addresses
res = ast.literal_eval(hosts_ip)

master_ips = res['master_public_ips']
workers_ips = res['worker_public_ips']

fout = open('hosts_test', 'w') # output ansible hosts file with ec2 public ip addresses
fout.write('[masters]' + "\n")

i = 1

for ip in master_ips:
   fout.write('master' + str(i) + ' ' + 'ansible_host=' + ip + '\n')
   i = i + 1

fout.write("\n")
fout.write('[add_workers]' + "\n")

j = 1

for ip in workers_ips:
   fout.write('worker' + str(j) + ' ' + 'ansible_host=' + ip + '\n')
   j = j + 1

fout.write('\n')
fout.write('[remove_workers]' + '\n')
fout.flush()
fout.close()