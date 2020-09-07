# Oozie组件

## Oozie简介

Oozie英文翻译为：驯象人。一个基于工作流引擎的开源框架，由Cloudera公司贡献给Apache，提供对Hadoop MapReduce、Pig Jobs的任务调度与协调。Oozie需要部署到Java Servlet容器中运行。主要用于定时调度任务，多任务可以按照执行的逻辑顺序调度。

## Oozie的功能模块介绍
### 模块
* Workflow <br/>
顺序执行流程节点，支持fork（分支多个节点），join（合并多个节点为一个）
* Coordinator <br/>
定时触发workflow
* Bundle <br/>
绑定多个Coordinator

### Workflow常用节点
* 控制流节点（Control Flow Nodes）<br/>
控制流节点一般都是定义在工作流开始或者结束的位置，比如start,end,kill等。以及提供工作流的执行路径机制，如decision，fork，join等。
* 动作节点（Action Nodes）<br/>
负责执行具体动作的节点，比如：拷贝文件，执行某个Shell脚本等等。


## Oozie安装相关文件位置及配置

* /usr/bin/  : 所有Oozie相关命令的软链，它们会再软链到/etc/alternatives中去
* /var/lib/ : Oozie服务相关数据目录
* /var/log/   : Oozie相关服务运行日志目录
* /opt/cloudera/parcels/CDH/jars   : Oozie所有相关服务的安装文件，包含jar包，配置文件以及执行命令等。
* /tmp  :所有Oozie相关服务不同角色的OOM堆栈转存目录。以及所有角色启动的pid文件

## Oozie架构
	node01:	192.168.1.89  
	node02:	192.168.1.98 
	node03:	192.168.115
	
	Oozie Server : node01
	


## Oozie的配置

### 修改Hadoop配置

#### core-site.xml

	<!-- Oozie Server的Hostname -->
	<property>
		<name>hadoop.proxyuser.liujh.hosts</name>
		<value>*</value>
	</property>
	
	<!-- 允许被Oozie代理的用户组 -->
	<property>
		<name>hadoop.proxyuser.liujh.groups</name>
	 	<value>*</value>
	</property>
	
#### mapred-site.xml

	<!-- 配置 MapReduce JobHistory Server 地址 ，默认端口10020 -->
	<property>
	    <name>mapreduce.jobhistory.address</name>
	    <value>hadoop102:10020</value>
	</property>
	
	<!-- 配置 MapReduce JobHistory Server web ui 地址， 默认端口19888 -->
	<property>
	    <name>mapreduce.jobhistory.webapp.address</name>
	    <value>hadoop102:19888</value>
	</property>
	
#### yarn-site.xml

	<!-- 任务历史服务 -->
	<property> 
		<name>yarn.log.server.url</name> 
		<value>http://hadoop102:19888/jobhistory/logs/</value> 
	</property>