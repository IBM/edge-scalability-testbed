ec2instances
=========

Create EC2 instance(s).

Requirements
------------

Python package `boto` is required.

Role Variables
--------------

Default role variables are defined in defaults/main.yml.

AWS credentials are NOT coded as role variables. They can be set by environment variables, e.g. `AWS_ACCESS_KEY` and `AWS_SECRET_KEY`.

Dependencies
------------

N/A

Example Playbook
----------------
```
---
- hosts: localhost
  roles:
    - role: ec2instances
      vars:
        instance_type: t2.micro
        count: 2

  post_tasks:
  - debug:
      msg:
      - "{{ ec2_creation }}"
      - "{{ public_ips }}"
      - "{{ private_ips }}"
```
