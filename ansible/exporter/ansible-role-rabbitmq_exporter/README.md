# Ansible Role: rabbitmq_exporter - 1.0.0

## Example Playook

```yaml
---
- hosts: rabbitmq
  become: yes
  roles:
    - rabbitmq_exporter-1.0.0
  vars:
    rabbitmq_exporter_url: "http://localhost:15672"
    rabbitmq_exporter_user: "global"
    rabbitmq_exporter_password: "global!"
    rabbitmq_exporter_address: "0.0.0.0"
    rabbitmq_exporter_listen_port: "9419"
    rabbitmq_exporter_logging_output_format: "TTY"
    rabbitmq_exporter_logging_level: "info"
```