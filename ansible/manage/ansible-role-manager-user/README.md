# Ansible Role: Manage - user

## Example Playook

```yaml
---
- hosts: all
  become: yes
  vars:
    append_groups:
      enabled: true
      groups: root, superadmin
    jump_inventory_hostname: vm-01
  tasks:
  - include_role:
      name: manage-user
    loop:
      - { target: two, exists: true, name: chen }
      - { target: two, exists: true, name: nivek }
      - { target: two, exists: true, name: joanchen }
```

## Lab Invnetory
```yaml
[vm01]
vm-01 ansible_host=ip ansible_user=root

[vm02]
vm-02 ansible_host=ip ansible_user=root

[one:children]
vm01

[two:children]
vm02
```