Cloudera Manager

功能+架构+日志+常见操作


功能:
简单来说，Cloudera Manager是一个拥有集群自动化安装、中心化管理、集群监控、报警功能的一个工具（软件）,
使得安装集群从几天的时间缩短在几个小时内，运维人员从数十人降低到几人以内，极大的提高集群管理的效率。


架构:

server node: 192.168.1.89
agent node: 192.168.1.89   192.168.1.98  192.168.115

架构说明:
Console端通过REST API调用Server端功能
Server端除了管理功能,还有一组执行各种监控，警报和报告功能角色的服务。主体使用Java实现,Agent与Server保持心跳，使用Thrift RPC框架.
Agent安装在每台主机上,该代理负责启动和停止的过程，拆包配置，触发装置和监控主机为客户端负责执行服务端发来的命令，执行方式一般为使用python调用相应的服务shell脚本.


主要目录位置:
/var/log/cloudera-scm-installer : 安装日志目录。  
  /var/log/* : 相关日志文件（相关服务的及CM的）。  
  /usr/share/cmf/ : 程序安装目录。  
  /usr/lib64/cmf/ : Agent程序代码。  
  /var/lib/cloudera-scm-server-db/data : 内嵌数据库目录。  
  /usr/bin/postgres : 内嵌数据库程序。  
  /etc/cloudera-scm-agent/ : agent的配置目录。  
  /etc/cloudera-scm-server/ : server的配置目录。  
  /opt/cloudera/parcels/ : Hadoop相关服务安装目录。  
  /opt/cloudera/parcel-repo/ : 下载的服务软件包数据，数据格式为parcels。  
  /opt/cloudera/parcel-cache/ : 下载的服务软件包缓存数据。  

  /etc/hadoop/* : 客户端配置文件目录。  
(其他组件比如zookeeper就是/etc/zookeeper/* )
 
常见操作:
通过console里的操作:
    • 管理：对集群进行管理，如添加、删除节点等操作。
    • 监控：监控集群的健康情况，对设置的各种指标和系统运行情况进行全面监控。
    • 诊断：对集群出现的问题进行诊断，对出现的问题给出建议解决方案。

限制:
5.12.1 express版本不限制管理的节点数(老版本限制50),也不需要使用商业版(商业版多了权限管理)


常见操作:

1.Cloudera Manager Server命令

开启, 停止, 和 重启 Cloudera Manager Server

1.1开启
$ sudo service cloudera-scm-server start

1.2停止
$ sudo service cloudera-scm-server stop 

1.3重启
$ sudo service cloudera-scm-server restart 




2.Cloudera Manager Agents命令

2.1开启
$ sudo service cloudera-scm-agent start

2.2清理开启
$ sudo service cloudera-scm-agent clean_start

彻底清除目录 /var/run/cloudera-scm-agent  ；删除所有的文件和子目录，然后执行命令

/var/run/cloudera-scm-agent包含磁盘上运行的Agent 的状态.

一些Agent的状态留在 /var/lib/cloudera-scm-agent，不应删除
更多信息, 查看 Server and Client Configuration 和 Process Management.

2.3停止
$ sudo service cloudera-scm-agent stop



2.4重启
$ sudo service cloudera-scm-agent restart



3.强制停止和重启Agents命令

注意： hard_stop, clean_restart, or hard_restart 命令杀掉主机上运行的服务进程

3.1强制停止
$ sudo service cloudera-scm-agent hard_stop

3.2强制重启
$ sudo service cloudera-scm-agent hard_restart

强制重启适用于下面情况：

1.Cloudera Manager升级，supervisord代码在当前版本与新版本之间发生变化，为了保证的升级，你也需要重启 supervisor
2.supervisord挂起，需要重新启动
3.清除与Cloudera Manager有关的运行状态及服务

3.3清理重启
$ sudo service cloudera-scm-agent clean_restart

先执行clean_start，然后执行hard_stop


4.检查Agents状态
检查Agents进程
$ sudo service cloudera-scm-agent status
