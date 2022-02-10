from ansible.module_utils.basic import *

def main():

    fields = {
        "public_ips": {"required": True, "type": "list"},
        "position": {"required": True, "type": "int"},
    }

    module = AnsibleModule(argument_spec=fields)

    public_ips = module.params["public_ips"]
    position = module.params["position"]
    master_public_ips = public_ips[:position]
    worker_public_ips = public_ips[position:]


    fout = open('.data/hosts', 'w') # output ansible hosts file with ec2 public ip addresses
    fout.write('[masters]' + "\n")

    i=1

    for ip in master_public_ips:
       fout.write('master' + str(i) + ' ' + 'ansible_host=' + ip + '\n')
       i +=1

    fout.write("\n")
    fout.write('[add_workers]' + "\n")

    j=1

    for ip in worker_public_ips:
       fout.write('worker' + str(j) + ' ' + 'ansible_host=' + ip + '\n')
       j+=1

    fout.write('\n')
    fout.write('[remove_workers]' + '\n')
    fout.flush()
    fout.close()

    module.exit_json(changed=True,
                     master_public_ips=master_public_ips,
                     worker_public_ips=worker_public_ips)

if __name__ == '__main__':
    main()
