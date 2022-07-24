from ansible.module_utils.basic import *
import re

def main():

    fields = {
        "inventory_name": {"required": True, "type": "str"},
        "inventory_group": {"required": True, "type": "str"},
    }

    module = AnsibleModule(argument_spec=fields)

    inventory_name = module.params["inventory_name"]
    inventory_group = module.params["inventory_group"]
    
    f = open('_'.join(['../.data/hosts', inventory_name ]), 'r') # output ansible hosts file with ec2 public ip addresses

    dict_list = {}
    for line in f:
       if inventory_group == "master":
          matchObj = re.match( r'master*', line)

       elif inventory_group == "worker":
          matchObj = re.match( r'worker*', line)

       if  matchObj:
          ip = line.strip("\n").split("=")[1]
          dict_list[ip] = 1
    f.close()

    ip_list = list(dict_list.keys())
    
    module.exit_json(changed=True, ip_list=ip_list)

if __name__ == '__main__':
    main()