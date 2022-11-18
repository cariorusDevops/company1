# Ansible Role: node_exporter - 1.3.1

## Example Playook

```yaml
---
- hosts: all
  become: yes
  roles:
    - node_exporter-1.3.1
  vars:
    exporter_log_level: info
    exporter_log_format: logfmt
    exporter_listen_address: "0.0.0.0:9100"
```