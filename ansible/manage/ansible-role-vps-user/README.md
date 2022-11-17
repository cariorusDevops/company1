# Ansible Role: vps-user

## Example Playook

```yaml
---
- hosts: vps
  become: yes
  tasks:
  - include_role:
      name: vps-user
    loop:
      - { exists: true, name: billy }
      - { exists: true, name: samchen }
      - { exists: true, name: nivek }