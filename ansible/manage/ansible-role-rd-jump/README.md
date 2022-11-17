# Ansible Role: RD - JUMP

## Example Playook

```yaml
---
- hosts: all
  become: yes
  vars:
    append_groups:
      enabled: true
      groups: root, superadmin
    rd_jump_inventory_hostname: development_jump
  tasks:
  - include_role:
      name: rd-jump
    loop:
      - { target: rd_jump, exists: true, name: chen }
      - { target: rd_jump, exists: true, name: nivek }
      - { target: rd_service, exists: true, name: rdtest }    
```

## Invnetory
```yaml
[rd_jump]
development_jump ansible_host=ip

[rd_service:children]
rd_jump
```