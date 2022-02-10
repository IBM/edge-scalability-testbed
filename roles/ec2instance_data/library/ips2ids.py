from ansible.module_utils.basic import *

def main():

    fields = {
        "ec2_instances": {"required": True, "type": "dict"},
    }

    module = AnsibleModule(argument_spec=fields)

    ec2_instances = module.params["ec2_instances"]
    instances = ec2_instances["instances"]

    module.exit_json(changed=False, first_public_ip=instances[0]["public_ip"])

if __name__ == '__main__':
    main()
