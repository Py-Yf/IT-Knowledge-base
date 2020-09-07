# 使用Impala

## Impala的外部shell <br/>

* 显示帮助信息 : `-h, --help`
*  显示版本信息 : `-v or --version`
*  指定连接运行 impalad 守护进程的主机。默认端口是 21000 : `-i hostname, --impalad=hostname`
*  从命令行中传递一个shell 命令。执行完这一语句后 shell 会立即退出 : `-q query, --query=query`
*  传递一个文件中的 SQL 查询。文件内容必须以分号分隔 : `-f query_file, --query_file= query_file`
*  保存所有查询结果到指定的文件。通常用于保存在命令行使用 -q 选项执行单个查询时的查询结果 : `-o filename or --output_file filename`
*  查询执行失败时继续执行 : `-c`
*  指定启动后使用的数据库，与建立连接后使用use语句选择数据库作用相同，如果没有指定，那么使用default数据库 : `-d default_db or --database=default_db`
*  建立连接后刷新 Impala 元数据 : `-r or --refresh_after_connect`
*  对 shell 中执行的每一个查询，显示其查询执行计划 : `-p, --show_profiles`
*  去格式化输出 : `-B  (--delimited)`
*  指定分隔符 : `--output_delimiter=character`
*  打印列名 : `--print_header`

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
