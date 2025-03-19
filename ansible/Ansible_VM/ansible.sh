#!/bin/bash

ansible-playbook playbook.yml -e "ansible_user=user ansible_password=pass ansible_become_method=su ansible_become_user=root ansible_become_password=pass" -vv
