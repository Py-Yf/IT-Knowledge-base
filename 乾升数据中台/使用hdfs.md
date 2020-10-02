# 使用HDFS

## Hadoop 使用常用命令<br/>
#### 基本命令
1. 启动zk
2. 启动journalnode:<br/>
       ` hadoop-daemons.sh start journalnode`
3. 格式化zkfc--让在zookeeper中生成ha节点<br/>
       `hdfs zkfc –formatZK`
4. 格式化hdfs<br/>
        `hadoop namenode –format`
5. 启动NameNode<br/>
       ` hadoop-daemon start namenode`
6. standby同步namenode的数据，并启动<br/>
        `hdfs namenode –bootstrapStandby`
7. 启动启动datanode<br/>
        `hadoop-daemons.sh start datanode`
8. 启动yarn<br/>
        `sbin/start-yarn.sh`
9. 启动zkfc<br/>
       ` hadoop-daemons.sh start zkfc`

       
<br/>   

#### 启动hadoop所有进程<br/>

	start-all.sh等价于start-dfs.sh + start-yarn.sh
	
#### 单进程启动<br/>

	start-dfs.sh
	sbin/start-yarn.sh..
	
#### 常用命令 <br/>

1. 	查看指定目录下内容<br/>
	`hdfs dfs –ls [文件目录]`
	`hdfs dfs -ls -R   /                   //显式目录结构`
2. 打开某个已存在文件<br/>
	`hdfs dfs –cat [file_path]`
3. 	将本地文件存储至hadoop<br/>
	` hdfs dfs –put [本地地址] [hadoop目录]`
4. 	将本地文件夹存储至hadoop<br/>
	`hdfs dfs –put [本地目录] [hadoop目录]`
5. 	将hadoop上某个文件down至本地已有目录下<br/>
	` hadoop dfs -get [文件目录] [本地目录]`
6.	删除hadoop上指定文件<br/>
	` hdfs  dfs –rm [文件地址]`
7.	删除hadoop上指定文件夹（包含子目录等） <br/>
	`hdfs dfs –rm [目录地址]`
8.  在hadoop指定目录内创建新目录<br/>
	`hdfs dfs –mkdir /user/t`
9. 	在hadoop指定目录下新建一个空文件<br/>
 	使用touchz命令：<br/>
 	`hdfs dfs  -touchz  /user/new.txt` <br/>
10. 将hadoop上某个文件重命名 <br/>
	使用mv命令：<br/>
	` hdfs dfs –mv  /user/test.txt  /user/ok.txt   （将test.txt重命名为ok.txt）`
11.	将hadoop指定目录下所有内容保存为一个文件，同时down至本地 <br/>
	`hdfs dfs –getmerge /user /home/t`
12.	将正在运行的hadoop作业kill掉<br/>
	` hadoop job –kill  [job-id]`
13.	 查看帮助<br/>
	` hdfs dfs -help `
	
#### 安全模式

1. 退出安全模式<br/>
	NameNode在启动时会自动进入安全模式。安全模式是NameNode的一种状态，在这个阶段，文件系统不允许有任何修改。<br>
      系统显示Name node in safe mode，说明系统正处于安全模式，这时只需要等待十几秒即可，也可通过下面的命令退出安全模式：<br/>
      `hadoop dfsadmin -safemode leave`
2. 进入安全模式<br/>
	在必要情况下，可以通过以下命令把HDFS置于安全模式:<br/>
	`hadoop dfsadmin -safemode enter`
	
#### 负载均衡

HDFS的数据在各个DataNode中的分布可能很不均匀，尤其是在DataNode节点出现故障或新增DataNode节点时。新增数据块时NameNode对DataNode节点的选择策略也有可能导致数据块分布不均匀。用户可以使用命令重新平衡DataNode上的数据块的分布：<br/>
	`/usr/local/hadoop$bin/start-balancer.sh`
