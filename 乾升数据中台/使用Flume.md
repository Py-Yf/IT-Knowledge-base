# Flume 使用

## 启动Flume agent
	bin/flume-ng agent --conf conf --conf-file /etc/conf/flume.conf --name a1 -Dflume.root.logger=INFO,console	
<br/>
参数	作用	举例 <br/>

*   参数：–conf 或 -c	
		指定配置文件夹，包含flume-env.sh和log4j的配置文件		例如：–conf conf
*   参数：–conf-file 或 -f	
   		配置文件地址	
  	 	例如：–conf-file conf/flume.conf
*    –name 或 -n <br/>
   		agent名称<br/>
    	 	例如：–name a1
*  	参数：-z	
   		zookeeper连接字符串	
   	 	例如-z zkhost:2181,zkhost1:2181
* 	参数：-p	
  		zookeeper中的存储路径前缀	
  	 	例如：-p /flume

## 以Spool 监测配置的目录下新增的文件为例

### 创建agent配置文件

 	
vi /etc/conf/spool.conf


	a1.sources = r1
	
	a1.sinks = k1
	
	a1.channels = c1

	# Describe/configure the source

	a1.sources.r1.type= spooldir
	
	a1.sources.r1.channels = c1
	
	a1.sources.r1.spoolDir = /home/hadoop/flume-1.5.0-bin/logs
	
	a1.sources.r1.fileHeader = true
	
	# Describe the sink
	
	a1.sinks.k1.type= logger
	
	# Use a channel which buffers events in memory

	a1.channels.c1.type= memory
	
	a1.channels.c1.capacity = 1000
	
	a1.channels.c1.transactionCapacity = 100

	# Bind the source and sink to the channel
	
	a1.sources.r1.channels = c1
	
	a1.sinks.k1.channel = c1

### 启动服务flume agent a1

 	
	flume-ng agent -c . -f /etc/conf/spool.conf -n a1 -Dflume.root.logger=INFO,console

### 追加文件到/opt/cloudera/parcels/CDH/lib/flume-ng/logs目录

 	
echo "spool test1" > /opt/cloudera/parcels/CDH/lib/flume-ng/logs/spool_text.log

(d)在m1的控制台，可以看到以下相关信息：

 Event: { headers:{file=/opt/cloudera/parcels/CDH/lib/flume-ng/logs/spool_text.log} body: 73 70 6F 6F 6C 20 74 65 73 74 31        spool test1 }

 