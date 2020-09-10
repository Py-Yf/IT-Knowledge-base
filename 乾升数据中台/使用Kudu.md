# 使用KUDU

## KUDU的API操作 <br/>

### 创建表



#### 连接指定的impala主机
 	impala-shell -i node01

#### 使用-q查询表中数据，并将数据写入文件中
	impala-shell -q 'select * from student' -o output.txt
	
#### 显示查询执行计划
	 impala-shell -p

#### 去格式化输出
	impala-shell -q 'select * from student' -B --output_delimiter="\t" -o output.txt
	
## Impala的内部shell

*  显示帮助信息 : `help	`
*  显示执行计划 : `explain <sql>	`
*  查询最近一次查询的底层信息 : `profile (查询完成后执行）`
*  不退出impala-shell执行shell命令 : `shell <shell>	`
*  显示版本信息 : `version	（同于impala-shell -v）`
*  连接impalad主机，默认端口21000 : `connect	（同于impala-shell -i）`
*  增量刷新元数据库 : `refresh <tablename>	`
*  全量刷新元数据库（慎用）: `invalidate metadata（同于 impala-shell -r）`
*  历史命令 : `history	`
