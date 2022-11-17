Redis-5.0.14 (Cluster)

佈署及操作都需使用 root user

### Install
```shell
yum install -y gcc make
tar xaf redis-5.0.14.tar.gz
mv /opt/redis-5.0.14 /opt/redis
cd /opt/redis && make 
 
mkdir /opt/redis/log
mkdir /opt/redis/pid
mkdir /opt/redis/cluster 
  
ln -s /opt/redis/src/redis-cli /usr/bin/redis-cli
ln -s /opt/redis/src/redis-server /usr/bin/redis-server
ln -s /opt/redis/src/redis-benchmark /usr/bin/redis-benchmark
ln -s /opt/redis/src/redis-sentinel /usr/bin/redis-sentinel
ln -s /opt/redis/src/redis-check-aof /usr/bin/redis-check-aof
ln -s /opt/redis/src/redis-check-rdb /usr/bin/redis-check-rdb
```

### Configure
```shell
mv ./redis.conf.txt /opt/redis
mv /opt/redis/redis.conf.txt /opt/redis/redis.conf

mv ./redis.service.txt /etc/systemd/system/redis.service
mv /etc/systemd/system/redis.service.txt /etc/systemd/system/redis.service
```

### Kernel
```shell
echo 'net.core.somaxconn=1024' >> /etc/sysctl.conf && sudo sysctl -p
echo 'vm.overcommit_memory=1' >> /etc/sysctl.conf && sudo sysctl -p
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.d/rc.local
systemctl start redis && systemctl enable redis
```

### Make cluster
```shell
redis-cli -a 'password' --cluster create ip:6379 ip:6379 ip:6379 ip:6379 ip:6379 ip:6379 --cluster-replicas 1
```

### Check
```shell
redis-cli -a 'password' -p 6379 cluster info
redis-cli -a 'password' --cluster check localhost:6379
```