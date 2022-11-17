# Ansible Role: redis - 5.0.14

## Example Playook

```yaml
---
- hosts: redis
  become: yes
  roles:
    - role: redis-5.0.14
```

## Ansible hosts

```
[redis]
redis01 ansible_host=ip 
redis02 ansible_host=ip 
redis03 ansible_host=ip
redis04 ansible_host=ip
redis05 ansible_host=ip
redis06 ansible_host=ip
```

## Make Cluster
```bash
redis-cli -a 'global!#' --cluster create ip:6379 ip:6379 ip:6379 ip:6379 ip:6379 ip:6379 --cluster-replicas 1 
```

## Check redis cluster

```bash
redis-cli -a 'global!#' -p 6379 cluster info
redis-cli -a 'global!#' --cluster check localhost:6379
```