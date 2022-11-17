# Ansible Role: rabbitmq - 3.7.15

## Example Playook

```yaml
---
- hosts: rabbitmq
  become: yes
  vars:
    rabbitmq_allnode: rabbitmq
    rabbitmq_firstnode: rabbitmq01
  roles:
    - rabbitmq-3.7.15
```

## Ansible hosts

```
[rabbitmq]
rabbitmq01 ansible_host=ip
rabbitmq02 ansible_host=ip
rabbitmq03 ansible_host=ip
```

## Check rabbitmq node & cluster

```bash
rabbitmqctl status
rabbitmqctl cluster_status
```