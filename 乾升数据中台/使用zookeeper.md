# 使用Zookeeper

## Zookeeper 使用常用命令<br/>
### ZooKeeper服务命令
1. 	 启动ZK服务<br/>
	`zkServer.sh start`
2.  查看ZK服务状态<br/>
	`zkServer.sh status`
3. 	停止ZK服务<br/>
	`zkServer.sh stop`
4. 	重启ZK服务<br/>
	`zkServer.sh restart`	
### zk客户端命令 <br/>

*  显示根目录下、文件： ls / 使用 ls 命令来查看当前 ZooKeeper 中所包含的内容
*  显示根目录下、文件： ls2 / 查看当前节点数据并能看到更新次数等数据
*  创建文件，并设置初始内容： create /zk "test" 创建一个新的 znode节点“ zk ”以及与它关联的字符串
*  获取文件内容： get /zk 确认 znode 是否包含我们所创建的字符串
*  修改文件内容： set /zk "zkbak" 对 zk 所关联的字符串进行设置
*  删除文件： delete /zk 将刚才创建的 znode 删除
*   退出客户端： quit
*  帮助命令： help
*  rmr命令: 删除节点命令，此命令与delete命令不同的是delete不可删除有子节点的节点，但是rmr命令可以删除，注意路径为绝对路径。
	如`rmr /zookeeper/znode`
*  delquota命令:删除配额，-n为子节点个数，-b为节点数据长度。
	如`delquota –n`
*  printwatches命令:	设置和显示监视状态，on或者off。
	如`printwatches on`
*  listquota命令:	显示配额。
	如`listquota /zookeeper`
	
	
