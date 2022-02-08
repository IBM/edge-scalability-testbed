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

    module.exit_json(changed=True,
                     master_public_ips=master_public_ips,
                     worker_public_ips=worker_public_ips)

if __name__ == '__main__':
    main()
