# 使用Spark

## 操作spark<br/>

启动spark：`start-all.sh`<br/>
启动Hadoop以及Spark：`./starths.sh`<br/>
停止Hadoop以及Spark：`stophs.sh`

### 基础使用

#### 运行Spark示例（SparkPi）

`run-example SparkPi 2>&1 | grep "Pi is roughly"`

#### 通过Spark-shell进行交互分析

Spark Shell 支持 Scala 和 Python，Scala 运行于 Java 平台（JVM，Java 虚拟机），并兼容现有的 Java 程序。Scala 是 Spark 的主要编程语言，如果仅仅是写 Spark 应用，并非一定要用 Scala，用 Java、Python 都是可以的。使用 Scala 的优势是开发效率更高，代码更精简，并且可以通过 Spark Shell 进行交互式实时查询，方便排查问题。<br/>

1. 启动Spark Shell<br/>
`spark-shell`

2.  基础操作<br/>
使用本地文件创建RDD：`val textFile = sc.textFile("file:///usr/local/spark/README.md")`<br/>
使用hdfs文件创建RDD：`val textfile = sc.textFile("/winnie/htest/test01.txt")`<br/>
使用集合创建RDD：<br/>

		sc.makeRDD(1 to 50)
		sc.makeRDD(Array("1", "2", "3"))
		sc.makeRDD(List(1,3,5))
		
	RDDs转化操作：
		
		map()          参数是函数，函数应用于RDD每一个元素，返回值是新的RDD 
		flatMap()      参数是函数，函数应用于RDD每一个元素，将元素数据进行拆分，变成迭代器，返回值是新的RDD 
		filter()       参数是函数，函数会过滤掉不符合条件的元素，返回值是新的RDD 
		distinct()     没有参数，将RDD里的元素进行去重操作 
		union()        参数是RDD，生成包含两个RDD所有元素的新RDD 
		intersection() 参数是RDD，求出两个RDD的共同元素 
		subtract()     参数是RDD，将原RDD里和参数RDD里相同的元素去掉 
		cartesian()    参数是RDD，求两个RDD的笛卡儿积

	RDDs行动操作：

		collect()       返回RDD所有元素 
		count()         RDD里元素个数，对于文本文件，为总行数
		first()         RRD中的第一个item，对于文本文件，为首行内容 
		countByValue()  各元素在RDD中出现次数 
		reduce()        并行整合所有RDD数据，例如求和操作 
		fold(0)(func)   和reduce功能一样，不过fold带有初始值 
		aggregate(0)(seqOp,combop) 和reduce功能一样，但是返回的RDD数据类型和原RDD不一样 
		foreach(func)   对RDD每个元素都是使用特定函数


