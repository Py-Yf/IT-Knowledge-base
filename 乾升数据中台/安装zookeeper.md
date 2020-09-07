# 安装Zookeeper <br/>

## Zookeeper功能 <br/>
ZooKeeper是一个开源的分布式协调服务，由雅虎创建，是Google Chubby的开源实现。ZooKeeper的设计目标是将那些复杂且容易出错的分布式一致性服务封装起来，构成一个高效可靠的原语集，并以一系列简单易用的接口提供给用户使用。<br/>

ZooKeeper是一个典型的分布式数据一致性的解决方案。分布式应用程序可以基于它实现诸如数据发布/订阅、负载均衡、命名服务、分布式协调/通知、集群管理、Master选举、分布式锁和分布式队列等功能。ZooKeeper可以保证如下分布式一致性特性。

* 顺序一致性<br/>
从同一个客户端发起的事务请求，最终将会严格按照其发起顺序被应用到ZooKeeper中。

* 原子性<br/>
所有事务请求的结果在集群中所有机器上的应用情况是一致的，也就是说要么整个集群所有集群都成功应用了某一个事务，要么都没有应用，一定不会出现集群中部分机器应用了该事务，而另外一部分没有应用的情况。

* 单一视图<br/>
无论客户端连接的是哪个ZooKeeper服务器，其看到的服务端数据模型都是一致的。

* 可靠性<br/>
一旦服务端成功地应用了一个事务，并完成对客户端的响应，那么该事务所引起的服务端状态变更将会被一直保留下来，除非有另一个事务又对其进行了变更。

* 实时性<br/>
通常人们看到实时性的第一反应是，一旦一个事务被成功应用，那么客户端能够立即从服务端上读取到这个事务变更后的最新数据状态。这里需要注意的是，ZooKeeper仅仅保证在一定的时间段内，客户端最终一定能够从服务端上读取到最新的数据状态。


## Zookeeper相关架构部署 <br/>
	node01:	192.168.1.89  
	node02:	192.168.1.98 
	node03:	192.168.115
	

## Zookeeper安装相关文件位置及配置

* /usr/bin/  : 所有Zookeeper相关命令的软链，它们会再软链到/etc/alternatives中去
* /var/lib/ : Zookeeper服务相关数据目录
* /var/log/   :Zookeeper相关服务运行日志目录
* /opt/cloudera/parcels/CDH/jars   : Zookeeper所有相关服务的安装文件，包含jar包，配置文件以及执行命令等。
* /tmp  :所有Zookeeper相关服务不同角色的OOM堆栈转存目录。以及所有角色启动的pid文件


## Zookeeper相关配置 <br/>

#### zoo.cfg

	maxClientCnxns=50
	# The number of milliseconds of each tick
	tickTime=2000
	# The number of ticks that the initial 
	# synchronization phase can take
	initLimit=10
	# The number of ticks that can pass between 
	# sending a request and getting an acknowledgement
	syncLimit=5
	# the directory where the snapshot is stored.
	dataDir=/var/lib/zookeeper
	# the port at which the clients will connect
	clientPort=2181
	# the directory where the transaction logs are stored.
	dataLogDir=/var/lib/zookeeper
	
<br/>

#### zoo_sample.cfg

	# The number of milliseconds of each tick
	tickTime=2000
	# The number of ticks that the initial 
	# synchronization phase can take
	initLimit=10
	# The number of ticks that can pass between 
	# sending a request and getting an acknowledgement
	syncLimit=5
	# the directory where the snapshot is stored.
	# do not use /tmp for storage, /tmp here is just 
	# example sakes.
	dataDir=/tmp/zookeeper
	# the port at which the clients will connect
	clientPort=2181
	#
	# Be sure to read the maintenance section of the 
	# administrator guide before turning on autopurge.
	#
	# http://zookeeper.apache.org/doc/current/zookeeperAdmin.html#sc_maintenance
	#
	# The number of snapshots to retain in dataDir
	#autopurge.snapRetainCount=3
	# Purge task interval in hours
	# Set to "0" to disable auto purge feature
	#autopurge.purgeInterval=1
	
<br/>

#### configuration.xsl

	<?xml version="1.0"?>
	<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<xsl:template match="configuration">
	<html>
	<body>
	<table border="1">
	<tr>
	 <td>name</td>
	 <td>value</td>
	 <td>description</td>
	</tr>
	<xsl:for-each select="property">
	<tr>
	  <td><a name="{name}"><xsl:value-of select="name"/></a></td>
	  <td><xsl:value-of select="value"/></td>
	  <td><xsl:value-of select="description"/></td>
	</tr>
	</xsl:for-each>
	</table>
	</body>
	</html>
	</xsl:template>
	</xsl:stylesheet>
	
<br/>