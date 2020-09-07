# 使用Oozie

## Oozie常用命令 <br/>

#### 提交作业，作业进入PREP状态 

	oozie job -oozie http://localhost:11000/oozie -config job.properties -submit 
	job: 14-20090525161321-oozie-joe

#### 执行已提交的作业

	oozie job -oozie http://localhost:11000/oozie -start 14-20090525161321-oozie-joe 
	
#### 直接运行作业

oozie job -oozie http://localhost:11000/oozie -config job.properties -run

#### 挂起作业，恢复作业
 挂起前状态（RUNNING , RUNNIINGWITHERROR or PREP状态） workflow job will be in SUSPENDED status.<br/>
 
	oozie job -suspend 0000004-180119141609585-oozie-hado-C

恢复作业，接着上面的挂起操作<br/>
 
 	oozie job -resume 0000004-180119141609585-oozie-hado-C	 	
#### 杀死作业 
 
	 oozie job -oozie http://localhost:11000/oozie -kill 14-20090525161321-oozie-joe

#### 改变作业参数，不能修改killed状态的作业 

	oozie job -oozie http://localhost:11000/oozie -change 14-20090525161321-oozie-joe -value endtime=2011-12-01T05:00Z;concurrency=100;2011-10-01T05:00Z 

#### 重新运行作业

	oozie job -rerun 0006360-160701092146726-oozie-hado-C  -refresh -action 477-479
	oozie job -rerun 0006360-160701092146726-oozie-hado-C -D oozie.wf.rerun.failnodes=false

#### 检查作业状态
	
	oozie job -oozie http://localhost:11000/oozie -info 14-20090525161321-oozie-joe
 
#### 查看日志

	oozie job -oozie http://localhost:11000/oozie -log 14-20090525161321-oozie-joe 

#### 检查xml文件是否合规 

	oozie validate myApp/workflow.xml

#### 提交pig作业 

	oozie pig -oozie http://localhost:11000/oozie -file pigScriptFile -config job.properties -X -param_file params
	
#### 提交MR作业

	oozie mapreduce -oozie http://localhost:11000/oozie -config job.properties
	
#### 查看共享库

	oozie admin -shareliblist sqoop
	
#### 动态更新共享库
如果有新添加的jar包，通过该命令即可动态刷新共享库list，不用重新启动oozie<br/>

	oozie admin -sharelibupdate


 
