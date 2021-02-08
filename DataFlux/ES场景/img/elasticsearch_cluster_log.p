#elasticsearch_cluster_log
#名称	描述
# level	日志级别。包括trace、debug、info、warn、error等（GC日志没有level）。
# host	生成日志的节点的IP地址。
# time  日志产生时间。
# event 日志事件信息。
# content 日志的主要内容。

#日志示例:
#[2021-01-31T20:03:48,589][DEBUG][o.e.a.a.c.n.t.c.TransportCancelTasksAction] [172.16.0.196] Sending remove ban for tasks with the parent [oVxInwieRxCkXsT0WADRbw:5731978] to the node [KkY42lwxRa-rRiJL71ylfg]
#org.elasticsearch.transport.RemoteTransportException: [172.16.0.194][172.16.0.194:9300][internal:cluster/coordination/join/validate]
#	at org.elasticsearch.transport.InboundHandler$RequestHandler.doRun(InboundHandler.java:264) ~[elasticsearch-7.6.1.jar:7.6.1]
#	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:628) [?:?]

grok(_, "\\[%{TIMESTAMP_ISO8601:date_time}\\]\\[%{LOGLEVEL:level}\\s?\\]\\[%{GREEDYDATA:event}\\s?\\] \\[%{IPORHOST:node_host}\\] %{GREEDYDATA:content}")

#grok(_, "%{GREEDYDATA:error_exception} \\[%{IPORHOST:node_host}\\]\\[%{HOSTPORT:node_hostport}\\]\\[%{GREEDYDATA:content}\\]")


#grok(_, "\\s?%{GREEDYDATA:error_exception} \\[%{GREEDYDATA:error_jar}\\:%{GREEDYDATA:error_jar_version}\\]")
#grok(_, "\\s?%{GREEDYDATA:error_exception} ~\\[%{GREEDYDATA:error_jar}\\:%{GREEDYDATA:error_jar_version}\\]")