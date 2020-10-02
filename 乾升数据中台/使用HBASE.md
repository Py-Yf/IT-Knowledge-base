# 使用HBASE 
## HBASE常用命令 <br/>
### 进入HBASE-Shell
	[root@node01 bin]# /usr/bin/hbase shell
		2020-09-04 13:50:43,406 INFO  [main] Configuration.deprecation: hadoop.native.lib is deprecated. Instead, use io.native.lib.available
	HBase Shell; enter 'help<RETURN>' for list of supported commands.
	Type "exit<RETURN>" to leave the HBase Shell
	Version 1.2.0-cdh5.12.1, rUnknown, Thu Aug 24 09:37:07 PDT 2017
	
	hbase(main):001:0> 

<br/>   

### 表结构<br/>
	
#### 创建表

语法：`create <table>, {NAME => <family>, VERSIONS => <VERSIONS>}`

#### 查看所有表

语法：`list`

#### 查看表详情

语法：`describe '<table>' 或  desc '<table>'`

#### 表修改

删除指定的列族: ` alter 'User', 'delete' => 'info'`

### 表数据
#### 插入数据

语法：`put <table>,<rowkey>,<family:column>,<value>`

#### 根据rowKey查询某个记录

语法：`get <table>,<rowkey>,[<family:column>,....]`

#### 查询所有记录

语法：`scan <table>, {COLUMNS => [ <family:column>,.... ], LIMIT => num}`

#### 统计表记录数

语法：`count <table>, {INTERVAL => intervalNum, CACHE => cacheNum}`

#### 删除

删除列 : `delete 'User', 'row1', 'info:age'` <br/>
删除所有行:  `deleteall 'User', 'row2'` <br/>
删除表中所有数据: `truncate 'User'`<br/>

### 表管理
####  禁用表 

语法：`disable 'User'`

#### 启用表

语法：`enable 'User'`

#### 测试表是否存在

语法：`exists 'User'`

#### 删除表

删除前，必须先disable<br/>

	hbase(main):030:0> drop 'TEST.USER'
	
	ERROR: Table TEST.USER is enabled. Disable it first.
	
	Here is some help for this command:
	Drop the named table. Table must first be disabled:
	  hbase> drop 't1'
	  hbase> drop 'ns1:t1'
	
	hbase(main):031:0> disable 'TEST.USER'
	0 row(s) in 2.2640 seconds
	
	hbase(main):033:0> drop 'TEST.USER'
	0 row(s) in 1.2490 seconds
	
	hbase(main):034:0> list
	TABLE
	SYSTEM.CATALOG
	SYSTEM.FUNCTION
	SYSTEM.SEQUENCE
	SYSTEM.STATS
	User
	5 row(s) in 0.0080 seconds
	
	=> ["SYSTEM.CATALOG", "SYSTEM.FUNCTION", "SYSTEM.SEQUENCE", "SYSTEM.STATS", "User"]
