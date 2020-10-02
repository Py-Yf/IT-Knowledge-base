# Sqoop 使用

## Sqoop import使用

Sqoop import：将数据从关系型数据库导入Hadoop 中

步骤1 ：Sqoop 与数据库Server通信，获取数据库表的元数据信息；

步骤2 ：Sqoop 启动一个Map- Only 的MR 作业，利用元数据信息并行将数据写入Hadoop

	sqoop import \ 
	--connect jdbc:mysql://mysql.example.com/sqoop \
	--username sqoop \ 
	--password sqoop \ 
	--table person --target-dir

参数说明:

	--connnect: 指定JDBC URL
	
	--username/password ：mysql 数据库的用户名
	
	--table ：要读取的数据库表
	
	--hadoop-home hadoop目录

## Sqoop Export 使用

将数据从Hadoop 导入关系型数据库导中

步骤1 ： Sqoop 与数据库Server通信，获取数据库表的元数据信息；

步骤2 ：并行导入数据： 将Hadoop 上文件划分成若干个split ； 每个split 由一个Map Task 进行数据导入
 
	sqoop export \ 
	--connect jdbc:mysql://mysql.example.com/sqoop \ 
	--username sqoop \ 
	--password sqoop \ 
	--table cities \ 
	--export-dir cities --fields-terminated-by

 参数说明:

	--connnect: 指定JDBC URL
	
	--username/password ：mysql 数据库的用户名
	
	--table ：要导入的数据库表
	
	export-dir ：数据在HDFS 上存放目录
 
## Sqoop与其他系统结合

Sqoop 可以与Oozie 、Hive 、Hbase 等系统结合

用户需要在sqoop-env.sh 中增加HBASE_HOME 、HIVE_HOME