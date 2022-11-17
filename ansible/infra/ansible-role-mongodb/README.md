# Ansible Role: MongoDB - 2.6.9

## Example Playook

```yaml
---
- hosts: mongodb
  become: yes
  vars:
    thegroups: mongodb
  roles:
    - mongodb-2.6.9
```

## Ansible hosts

```
[mongodb]
mongodb01 ansible_host=ip
mongodb02 ansible_host=ip
mongodb03 ansible_host=ip
```

## Make Replicaset

The <mongodb hostname> corresponds to '/etc/hosts'

```bash
mongo
use admin
db.auth("admin", "NqUCHrKC5NMy2Dgd");

rs.initiate()
rs.conf()

rs.add("<mongodb_hostname>:27017")
rs.add("<mongodb_hostname>:27017")
rs.status()
```

## Check Replicaset

```bash
mongo
use admin
db.auth("admin", "NqUCHrKC5NMy2Dgd");
db.adminCommand( { replSetGetStatus : 1 } );
```

## Adjust master/slave priority

```bash
cfg = rs.conf()
cfg.members[0].priority = 1
cfg.members[1].priority = 0.5
cfg.members[2].priority = 0.3
rs.reconfig(cfg)

rs.conf()
```

## Check mongodb user

1. Admin
```bash
mongo
use admin
db.auth("admin", "NqUCHrKC5NMy2Dgd");
db.getUser("admin")
```

2. RD 
```bash
mongo
use admin
db.auth("admin", "NqUCHrKC5NMy2Dgd");
use global_mongo_db
db.getUser("global")
```

## Manual create user

1. Admin

```bash
mongo
use admin
db.createUser( 
  {
    user: "admin",
    pwd: "NqUCHrKC5NMy2Dgd",
    roles: [ { role: "root", db: "admin" } ]
  }
);
```

2. RD
```bash
use global_mongo_db 
db.createUser( 
  { 
    user: 'global', 
    pwd: 'global!@', 
    roles: [ { role: 'readWrite', db: 'global_mongo_db' } ] 
  }
); 
```