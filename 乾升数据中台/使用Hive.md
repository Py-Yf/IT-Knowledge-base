# 使用Hive

## Hive常用命令 <br/>

### Hive 常用函数
#### 设置运行内存

	set mapreduce.map.memory.mb = 1024;
	set mapreduce.reduce.memory.mb = 1024;

#### 设置变量

	set hivevar: var1 = -0.3;  --常数
	set hivevar: pre_month = date_add(date1, -30);

#### 删除表

	use xxxdb; 
	drop table table_name;

#### 删除分区
注意：若是外部表，则还需要删除文件`(hadoop fs -rm -r -f hdfspath)` <br/>

`alter table table_name drop if exists partitions (d='2019-05-20');`

#### if 函数

	if(boolean condition, a, b)

#### 将字符串类型的数据读取为json类型，并得到其中的元素key的值

	get_json_object(string s, '$.key')
	E.g. get_json_object(newexdata['data'], '$.module')

#### Url解析

	parse_url()
	--返回'facebook.com' 
	parse_url('http://faceb
	ook.com/path/p1.php?query=1','HOST')
	-- 返回'/path/p1.php' 
	parse_url('http://facebook.com/path/p1.php?query=1','PATH')
	-- 返回'query=1'
	parse_url('http://facebook.com/path/p1.php?query=1','QUERY')

#### 返回当前时间

	from_unixtime(unix_timestamp(). 'yyyy-MM-dd HH:mm:ss')
	
#### 字符串截取

	substring(string A， int start， int len)
	
#### 字符串连接

	concat(string A, string B, string C, ...)	

#### 自定义分隔符sep的字符串连接

	concat_ws(string sep, string A, string B, string C, ...)

#### 类型转换

	cast(expr as type)
	
#### 返回第一个非空参数

	coalesce()
	
#### 将一列数据拆成多行数据

	lateralView: LATERAL VIEW udtf(expression) tableAlias AS columnAlias (',' columnAlias)
	fromClause: FROM baseTable (lateralView)
	
	 -- 例子
	select pageid, adid
	from tmp Lateral view explode(adid_list) adTable AS adid 
	
	-- find_in_set : The FIND_IN_SET() function returns the position of a string within a list of strings.
	FIND_IN_SET(string, string_list)
	
### hive的分区和分桶
	
* 注意语句结构需要加分号;


#### 创建一个分区表

	create table invites(id int, name string) partitioned by (d string)
	row fomat delimited 
	fileds terminated by '\t'
	stored as textfile;

#### 将数据添加到 '2020-09-04' 分区中

load data local inpath '/home/hadoop/data.txt' overwrite into table invites partition(d = '2020-09-04');
	
#### 从分区中查询数据

	select *
	from invites
	where d = '2020-09-04';

#### 往一个分区表中的某个分区添加数据

	insert overwrite tableinvites partition (d = '2020-09-05')
	select *
	from test;
	
#### 查看分区情况
	
	hadoop fs -ls /home/hadoop.hive/warehouse/invites
	-- 或者
	show partitions table name;

### hive 桶(Bucket)

桶是更为细粒度的数据范围划分

* 获得更高的查询处理效率
* 取样（sampling）更高效
* 使用 Clustered by 子句来划分桶所用的列和桶的个数

#### hive 使用 id 列上的值， 除以桶数取余， id mod 4 (hash )

	create table bucketed_user(id INT, nmae String)
	Clustered by (id) INTO 4buckets;

#### 插入数据

	insert overwrite table bucketed_users
	select * from users;
	
#### 对桶中数据进行采样

	select *
	from bucketed_users
	tablesample(bucket 1 out of 4 ON id) 
	-- 注：tablesample是抽样语句，语法：TABLESAMPLE(BUCKET x OUTOF y)
	-- y必须是table总bucket数的倍数或者因子。hive根据y的大小，决定抽样的比例。例
	-- 如，table总共分了64份，当y=32时，抽取(64/32=)2个bucket的数据，当y=128时，
	-- 抽取(64/128=)1/2个bucket的数据。x表示从哪个bucket开始抽取。例如，table总
	-- bucket数为32，tablesample(bucket 3 out of 16)，表示总共抽取（32/16=）2
	-- 个bucket的数据，分别为第3个bucket和第（3+16=）19个bucket的数据。

### hive 表操作

分区表

* 连续数据报表制作需要分区表

删除分区

	ALTER TABLE tablename DROP IF EXISTS PARTITION(d = '2019-01-23');删除掉指定分区
	
严格模式

	SET hive.mapred.mode = strict/nonstrict
	
-- 默认为 nonstict非严格模式<br/>
​ 查询限制

1. ​ ​对于分区表，必须添加where对于分区字段的条件过滤
2. order by语句必须包含limit输出限制
3. 限制执行笛卡尔积的查询



