# Ansible Role: ElasticSearch - 6.3.0

## Example Playook

```yaml
---
- hosts: es
  become: yes
  roles:
    - java-1.8.0_161
    - elasticsearch-6.3.0
  vars:
    thegroups: es
    es_config:
      cluster.name: "wanbo-es"
    jvm_config:
      heap_size: 512m
    append_groups:
      enabled: true
      groups: root, superadmin
```

## Ansible hosts

```
[es]
elasticsearch01 ansible_host=ip 
elasticsearch02 ansible_host=ip 
elasticsearch03 ansible_host=ip 
```

## Elasticsearch API

```bash
curl localhost:9200/_cat/nodes?pretty
curl localhost:9200/_cat/health?pretty
curl localhost:9200/_cat/recovery?pretty
curl localhost:9200/_cluster/health?pretty
```