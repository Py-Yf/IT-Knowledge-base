# 使用KUDU

## KUDU的常用API操作 <br/>

### 创建表

	/**
	    * 创建表
	    */
	  def createTable(client: KuduClient, tableName: String): Unit = {
	    import scala.collection.JavaConverters._
	    val columns = List(
	      new ColumnSchema.ColumnSchemaBuilder("id", Type.STRING).key(true).build(),
	      new ColumnSchema.ColumnSchemaBuilder("name", Type.INT32).build()
	    ).asJava
	    val schema = new Schema(columns)
	    val options: CreateTableOptions = new CreateTableOptions()
	    options.setNumReplicas(1)
	    val parcols: util.LinkedList[String] = new util.LinkedList[String]()
	    parcols.add("word")
	    options.addHashPartitions(parcols,3)
	    client.createTable(tableName,schema,options)
	    }
	    
### 插入数据


	  def insertRows(client: KuduClient, tableName: String) = {
	    val table: KuduTable = client.openTable(tableName)  // 根据表名获取kudu的表
	    val session: KuduSession = client.newSession() // JPA Hibernate
	 
	    for(i<-1 to 10) {
	      val insert: Insert = table.newInsert()
	      val row: PartialRow = insert.getRow
	      row.addString("id", 100+i)
	      row.addInt("name",s"test-$i")
	 
	      session.apply(insert)
	    }
	 }
	 
### 修改表结构

	 def renameTable(client: KuduClient, tableName: String, newTableName: String) = {
	 
	    val options: AlterTableOptions = new AlterTableOptions()
	    options.renameTable(newTableName)
	    client.alterTable(tableName, options)
	  }
	 
### 查询数据

	def query(client: KuduClient, tableName: String) = {
	    val table: KuduTable = client.openTable(tableName)
	 
	    val scanner: KuduScanner = client.newScannerBuilder(table).build()
	 
	    while(scanner.hasMoreRows) {
	      val iterator: RowResultIterator = scanner.nextRows()
	 
	      while(iterator.hasNext) {
	        val result: RowResult = iterator.next()
	        println(result.getString("id") + " => " + result.getInt("name"))
	      }
	    }	 
	  }

### 修改数据

	def upsertRow(client: KuduClient, tableName: String) = {
	    val table: KuduTable = client.openTable(tableName)
	    val session: KuduSession = client.newSession()
	 
	    val update: Update = table.newUpdate()
	    val row: PartialRow = update.getRow
	    row.addString("word", "pk-10")
	    row.addInt("cnt", 8888)
	    session.apply(update)
	  }

### 删除表

	def deleteTable(client: KuduClient, tableName: String) = {
	    client.deleteTable(tableName)
	  }
	  
	  