# Ansible Role: elasticsearch_exporter - 1.3.0

## Example Playook

```yaml
---
- hosts: es
  become: yes
  roles:
    - elasticsearch_exporter-1.3.0
  vars:
    mode_cluster: true
    es_exporter_uri: "http://localhost:9200"
    es_exporter_timeout: "20s"
    es_exporter_clusterinfo_interval: "5m"
    exporter_listen_address: "0.0.0.0:9114"
```