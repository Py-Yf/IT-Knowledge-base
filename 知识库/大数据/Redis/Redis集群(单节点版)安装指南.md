
## Redis集群简介Redis 是一个开源的 key-value 存储系统，由于出众的性能，大部分互联网企业都用来做服务器端缓存。Redis 在3.0版本前只支持单实例模式，虽然支持主从模式、哨兵模式部署来解决单点故障，但是现在互联网企业动辄大几百G的数据，可完全是没法满足业务的需求，所以，Redis 在 3.0 版本以后就推出了集群模式。
Redis 集群采用了P2P的模式，完全去中心化。Redis 把所有的 Key 分成了 16384 个 slot，每个 Redis 实例负责其中一部分 slot 。集群中的所有信息（节点、端口、slot等），都通过节点之间定期的数据交换而更新。
Redis 客户端可以在任意一个 Redis 实例发出请求，如果所需数据不在该实例中，通过重定向命令引导客户端访问所需的实例。
## Redis单节点安装
```shell
# 下载redis安装包
wget -c http://download.redis.io/releases/redis-6.0.8.tar.gz

# 安装redis依赖组件
yum install gcc
yum -y install centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
# 启动gcc
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
yum install tcl

# 解压并编译redis源码包
tar xzf redis-6.0.8.tar.gz
cd redis-6.0.8
make PREFIX=/usr/local/redis install
# 启动redis server
src/redis-server
```
![941b403b-a111-424a-9869-2b4f2d042d0e.png](Redis集群(单节点版)安装指南_files/941b403b-a111-424a-9869-2b4f2d042d0e.png)
## Redis集群安装
### 1. 创建文件夹
我们计划集群中 Redis 节点的端口号为 `9001-9006` ，端口号即集群下各实例文件夹。数据存放在 `端口号/data` 文件夹中。
![mkdir_9001-9006](Redis集群(单节点版)安装指南_files/214a749d-9b71-4226-92b8-c8e1fbbfc60a.png)
```shell
mkdir /usr/local/redis-cluster
cd redis-cluster/
mkdir -p 9001/data 9002/data 9003/data 9004/data 9005/data 9006/data
```
### 2. 复制执行脚本
在 `/usr/local/redis-cluster `下创建` bin `文件夹，用来存放集群运行脚本，并把安装好的 Redis 的 `src `路径下的运行脚本拷贝过来。看命令：
```shell
mkdir redis-cluster/bin
cd /usr/local/redis/src
cp mkreleasehdr.sh redis-benchmark redis-check-aof redis-check-dump redis-cli redis-server redis-trib.rb /usr/local/redis-cluster/bin
```
### 3. 复制一个新 Redis 实例
我们现在从已安装好的 Redis 中复制一个新的实例到` 9001 ` 文件夹，并修改` redis.conf `配置。
![mv9001](Redis集群(单节点版)安装指南_files/d6f47776-7f31-4528-b144-7e561b1fa8ba.png)
```shell
cp /usr/local/redis/* /usr/local/redis-cluster/9001
```
注意，修改` redis.conf `配置和单点唯一区别是下图部分，其余还是常规的这几项：
```bash
port 9001（每个节点的端口号）
daemonize yes
bind 192.168.119.131（绑定当前机器 IP，是匹配当前机器的网卡 IP，阿里云上EIP无法绑定）
dir /usr/local/redis-cluster/9001/data/（数据文件存放位置）
pidfile /var/run/redis_9001.pid（pid 9001和port要对应）
cluster-enabled yes（启动集群模式）
cluster-config-file nodes9001.conf（9001和port要对应）
cluster-node-timeout 15000
appendonly yes
```
集群搭建配置重点就是取消下图中的这三个配置的注释：
![cluster_conf](Redis集群(单节点版)安装指南_files/cee39d3b-436b-428f-b5c4-c72593367ae1.png)
### 4. 再复制出五个新 Redis 实例
我们已经完成了一个节点了，其实接下来就是机械化的再完成另外五个节点，其实可以这么做：把` 9001 `实例 复制到另外五个文件夹中，唯一要修改的就是` redis.conf `中的所有和端口的相关的信息即可，其实就那么四个位置。开始操作，看图：
![cp9001-9006](Redis集群(单节点版)安装指南_files/9a8d1a97-c6cd-4529-8cb3-ace04029ddf3.png)
```shell
\cp -rf /usr/local/redis-cluster/9001/* /usr/local/redis-cluster/9002
\cp -rf /usr/local/redis-cluster/9001/* /usr/local/redis-cluster/9003
\cp -rf /usr/local/redis-cluster/9001/* /usr/local/redis-cluster/9004
\cp -rf /usr/local/redis-cluster/9001/* /usr/local/redis-cluster/9005
\cp -rf /usr/local/redis-cluster/9001/* /usr/local/redis-cluster/9006
```
`\cp -rf `命令是不使用别名来复制，因为 `cp` 其实是别名 `cp -i`，操作时会有交互式确认，比较烦人。
### 5. 修改 9002-9006 的 redis.conf 文件
其实非常简单了，你通过搜索会发现其实只有四个点需要修改，我们全局替换下吧，进入相应的节点文件夹，做替换就好了。命令非常简单，看图：
![82036016.png](Redis集群(单节点版)安装指南_files/82036016.png)
```vim
vim redis.conf
:%s/9001/9002
```
回车后，就会有替换几个地方成功的提示，不放心可以手工检查下：
![%s-success](Redis集群(单节点版)安装指南_files/5e6b6283-9117-401f-b864-8b3d03baaef5.png)
其实我们也就是替换了下面这四行：
```shell
port 9002
dir /usr/local/redis-cluster/9002/data/
cluster-config-file nodes-9002.conf
pidfile /var/run/redis_9002.pid
```
到这里，我们已经把最基本的环境搞定了，接下来就是启动了。
## 启动Redis集群
### 1. 启动 9001-9006 六个节点
![redis-server_start](Redis集群(单节点版)安装指南_files/7903524e-9905-4d49-af34-0230c537e7ce.png)
```shell
/usr/local/bin/redis-server /usr/local/redis-cluster/9001/redis.conf 
/usr/local/bin/redis-server /usr/local/redis-cluster/9002/redis.conf 
/usr/local/bin/redis-server /usr/local/redis-cluster/9003/redis.conf 
/usr/local/bin/redis-server /usr/local/redis-cluster/9004/redis.conf 
/usr/local/bin/redis-server /usr/local/redis-cluster/9005/redis.conf 
/usr/local/bin/redis-server /usr/local/redis-cluster/9006/redis.conf
```
可以检查一下是否启动成功：`ps -el | grep redis`
看的出来，六个节点已经全部启动成功了。
### 2. 随便找一个节点测试试
![redis-server_start_test](Redis集群(单节点版)安装指南_files/9c7567c4-0fc5-4527-97e0-003e9edfd6b8.png)
```shell
/usr/local/redis-cluster/bin/redis-cli -h 192.168.119.131 -p 9001

set name mafly
```
报错这是因为虽然我们配置并启动了 Redis 集群服务，但是他们暂时还并不在一个集群中，互相直接发现不了，而且还没有可存储的位置，就是所谓的slot。
### 3. 安装集群所需软件
由于 Redis 集群需要使用 ruby 命令，所以我们需要安装 ruby 和相关接口。
![yum_ruby](Redis集群(单节点版)安装指南_files/5298cbd0-3689-4219-8eeb-b7536d1b1744.png)
```
yum install ruby
yum install rubygems
gem install redis 
```
CentOS7 yum库中ruby的版本支持到 2.0.0，但是gem安装redis需要最低是2.3.0，采用rvm来更新ruby：
#### 3.1 安装curl
```
yum -y install  curl
```
#### 3.2 安装rvm
```
gpg2  --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3  
curl -L get.rvm.io | bash -s stable 
```
可能会遇见以下错误：
```shell
[root@localhost ~]# curl -L get.rvm.io | bash -s stable
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   194  100   194    0     0    242      0 --:--:-- --:--:-- --:--:--   242
100 24168  100 24168    0     0  10201      0  0:00:02  0:00:02 --:--:-- 42474
Downloading https://github.com/rvm/rvm/archive/1.29.8.tar.gz
Downloading https://github.com/rvm/rvm/releases/download/1.29.8/1.29.8.tar.gz.asc
gpg: 于 2019年05月08日 星期三 22时14分49秒 CST 创建的签名，使用 RSA，钥匙号 39499BDB
gpg: 无法检查签名：没有公钥
GPG signature verification failed for '/usr/local/rvm/archives/rvm-1.29.8.tgz' - 'https://github.com/rvm/rvm/releases/download/1.29.8/1.29.8.tar.gz.asc'! Try to install GPG v2 and then fetch the public key:
 
    gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
 
or if it fails:
 
    command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
 
In case of further problems with validation please refer to https://rvm.io/rvm/security
```
根据上面提示，安装前先执行
```
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E37D2BAF1CF37B13E2069D6956105BD0E739499BDB
```
#### 3.3 修改 rvm下载 ruby的源，到 Ruby China 的镜像
``` 
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
```
#### 3.4 添加rvm命令
```
# find / -name rvm -print
/usr/local/rvm 
/usr/local/rvm/src/rvm 
/usr/local/rvm/src/rvm/bin/rvm 
/usr/local/rvm/src/rvm/lib/rvm 
/usr/local/rvm/src/rvm/scripts/rvm 
/usr/local/rvm/bin/rvm 
/usr/local/rvm/lib/rvm 
/usr/local/rvm/scripts/rvm
    
# source /usr/local/rvm/scripts/rvm
```
#### 3.5 查看rvm库中已知的ruby版本
```
rvm list known
```
#### 3.6 安装一个ruby版本
```
rvm install 2.4.10
```
#### 3.7 使用一个ruby版本
```
rvm use 2.4.10
```
#### 3.8 设置默认版本
```
rvm use 2.4.10 --default
```
#### 3.9 卸载一个已知版本
```
rvm remove 2.0.0
```
#### 3.10 查看ruby版本
```
ruby --version
```
#### 3.11 安装Redis
```
gem install redis
Fetching: redis-4.0.0.gem (100%) 
Successfully installed redis-4.0.0 
Parsing documentation for redis-4.0.0 
Installing ri documentation for redis-4.0.0 
Done installing documentation for redis after 1 seconds 
1 gem installed
```
### 4.创建集群
![cluster_create](Redis集群(单节点版)安装指南_files/b294759f-cc4c-46f1-a849-17667d968942.png)
```
/usr/local/redis-cluster/bin/redis-trib.rb create --replicas 1 192.168.119.131:9001 192.168.119.131:9002 192.168.119.131:9003 192.168.119.131:9004 192.168.119.131:9005 192.168.119.131:9006
```
简单解释一下这个命令：调用 ruby 命令来进行创建集群，`--replicas 1` 表示主从复制比例为 1:1，即一个主节点对应一个从节点；然后，默认给我们分配好了每个主节点和对应从节点服务，以及 solt 的大小，因为在 Redis 集群中有且仅有 16383 个 solt ，默认情况会给我们平均分配，当然你可以指定，后续的增减节点也可以重新分配。

`M: 10222dee93f6a1700ede9f5424fccd6be0b2fb73` 为主节点Id

`S: 9ce697e49f47fec47b3dc290042f3cc141ce5aeb 192.168.119.131:9004 replicates 10222dee93f6a1700ede9f5424fccd6be0b2fb73` 从节点下对应主节点Id

目前来看，`9001-9003` 为主节点，`9004-9006` 为从节点，并向你确认是否同意这么配置。输入 `yes `后，会开始集群创建。
![cluster_create_success](Redis集群(单节点版)安装指南_files/e78537b8-2532-4bc2-8bbb-aded8ccd09d9.png)
上图则代表集群搭建成功啦！！！

### 5. 验证
依然是通过客户端命令连接上，通过集群命令看一下状态和节点信息等。
![cluster_info](Redis集群(单节点版)安装指南_files/5b0d2071-172b-4f67-b0e1-61f00b632740.png)
```
/usr/local/redis-cluster/bin/redis-cli -c -h 192.168.119.131 -p 9001
cluster info
cluster nodes
```
通过命令，可以详细的看出集群信息和各个节点状态，主从信息以及连接数、槽信息等。这么看到，我们已经真的把 Redis 集群搭建部署成功啦！
设置一个 mafly：
你会发现，当我们 `set name mafly `时，出现了 `Redirected to slot` 信息并自动连接到了9002节点。这也是集群的一个数据分配特性，这里不详细说了。
![redirected_9002](Redis集群(单节点版)安装指南_files/a7b182b6-62ce-4700-92cf-71defe506b29.png)



