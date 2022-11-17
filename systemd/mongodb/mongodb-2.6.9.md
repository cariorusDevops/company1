MongoDB-2.6.9 (PSS)

佈署及操作都需使用 root user

### Install
```shell
(需與HOSTNAME同名)
vi /etc/hosts
IP  HostName01
IP  HostName02
IP  HostName03

groupadd mongod
useradd -d /opt/mongodb -g mongod -M -s /bin/false mongod

tar xaf mongodb-linux-x86_64-2.6.9.tgz
mv /opt/mongodb-linux-x86_64-2.6.9 /opt/mongodb

mkdir /opt/mongodb/key
mkdir /opt/mongodb/log
mkdir /opt/mongodb/pid
mkdir /opt/mongodb/data
```

### Configure
```shell
vi /etc/bashrc
MONGODB_BIN=/opt/mongodb/bin
export PATH=$PATH:$MONGODB_BIN

source /etc/bashrc

mv ./mongod_init.conf.txt /opt/mongodb
mv /opt/mongodb/mongod_init.conf.txt /opt/mongodb/mongod.conf

mv ./mongod.service.txt /etc/systemd/system
mv /etc/systemd/system/mongod.service.txt /etc/systemd/system/mongod.service

# 啟動服務
systemctl start mongod && systemctl enable mongod

# 新增 ADMIN 用戶
mongo	
use admin
db.createUser( 
  {
    user: "admin",
    pwd: "password",
    roles: [ { role: "root", db: "admin" } ]
  }
);

# 新增 RD 用戶
use global_mongo_db 
db.createUser( 
  { 
    user: 'global', 
    pwd: 'password', 
    roles: [ { role: 'readWrite', db: 'global_mongo_db' } ] 
  }
);

# 在 主節點上執行
openssl rand -base64 756 > /opt/mongodb/key/mongodb-key
chmod 400 /opt/mongodb/key/mongodb-key

# 複製 主節點 'mongodb-key' 內容至其他節點上
vi /opt/mongodb/key/mongodb-key
chmod 400 /opt/mongodb/key/mongodb-key

rm -rf /opt/mongodb/mongod.conf
mv ./mongod_formal.conf.txt /opt/mongodb/mongod.conf

# 重啟服務
systemctl restart mongo
```

### Make replica
```shell
mongo
use admin
db.auth("admin", "password");

rs.initiate()
rs.conf()

rs.add("<mongodb_hostname>:27017")
rs.add("<mongodb_hostname>:27017")
rs.status()
```

### Adjust master/slave priority
```shell
cfg = rs.conf()
cfg.members[0].priority = 1
cfg.members[1].priority = 0.5
cfg.members[2].priority = 0.3
rs.reconfig(cfg)

rs.conf()
```

### Check
```shell
# 檢查 PSS
mongo
use admin
db.auth("admin", "password");
db.adminCommand( { replSetGetStatus : 1 } );

# 檢查 PSS Priority
mongo
use admin
db.auth("admin", "password");
rs.conf();

# 檢查 ADMIN 用戶
mongo
use admin
db.auth("admin", "password");
db.getUser("admin")

# 檢查 RD 用戶
mongo
use admin
db.auth("admin", "password");
use global_mongo_db
db.getUser("global")
```