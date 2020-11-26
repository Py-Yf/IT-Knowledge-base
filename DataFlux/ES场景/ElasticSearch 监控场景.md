# ElasticSearch 监控场景

### 简介
Elasticsearch提供了许多指标，可以帮助您检测故障迹象并在遇到不可靠的节点，内存不足的错误以及较长的垃圾收集时间等问题时采取措施。需要监视的几个关键领域是：

* 搜索和索引性能
* 内存和垃圾回收
* 主机级系统和网络指标
* 集群运行状况和节点可用性
* 资源饱和和错误

### 前置条件
* 需安装 DataKit，并配置 ElasticSearch 采集源。


### 配置
进入 DataKit 安装目录下的 `conf.d/db` 目录，复制 `elasticsearch.conf.sample` 并命名为 `elasticsearch.conf`。示例如下：

	# Read stats from one or more Elasticsearch servers or clusters
	 [[inputs.elasticsearch]]
	   ## specify a list of one or more Elasticsearch servers
	   # you can add username and password to your url to use basic authentication:
	   # servers = ["http://user:pass@localhost:9200"]
	   servers = ["http://localhost:9200"]
	
	   ## Timeout for HTTP requests to the elastic search server(s)
	   http_timeout = "5s"
	
	   ## When local is true (the default), the node will read only its own stats.
	   ## Set local to false when you want to read the node stats from all nodes
	   ## of the cluster.
	   local = true
	
	   ## Set cluster_health to true when you want to also obtain cluster health stats
	   cluster_health = false
	
	   ## Adjust cluster_health_level when you want to also obtain detailed health stats
	   ## The options are
	   ##  - indices (default)
	   ##  - cluster
	   # cluster_health_level = "indices"
	
	   ## Set cluster_stats to true when you want to also obtain cluster stats.
	   cluster_stats = false
	
	   ## Only gather cluster_stats from the master node. To work this require local = true
	   cluster_stats_only_from_master = true
	
	   ## Indices to collect; can be one or more indices names or _all
	   indices_include = ["_all"]
	
	   ## One of "shards", "cluster", "indices"
	   indices_level = "shards"
	
	   ## node_stats is a list of sub-stats that you want to have gathered. Valid options
	   ## are "indices", "os", "process", "jvm", "thread_pool", "fs", "transport", "http",
	   ## "breaker". Per default, all stats are gathered.
	   # node_stats = ["jvm", "http"]
	
	   ## HTTP Basic Authentication username and password.
	   # username = ""
	   # password = ""
	
	   ## Optional TLS Config
	   # tls_ca = "/etc/telegraf/ca.pem"
	   # tls_cert = "/etc/telegraf/cert.pem"
	   # tls_key = "/etc/telegraf/key.pem"
	   ## Use TLS but skip chain & host verification
	   # insecure_skip_verify = false
   
   
重新启动datakit

`systemctl restart datakit`	        

### 采集指标

#### 指标集 `elasticsearch_cluster_health`

前置条件：

* cluster_health = true

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|	name	|			|

指标

|	指标	|	描述	|	类型	|	单位	|
|	:----:	|	:----:	|	:----:	|	:----:	|
|	active_primary_shards	|	-	|	integer	|	-	|
|	active_shards		|	-	|	integer	|	-|	
|	active_shards_percent_as_number	|	-	|	float	|	-	|
|	delay_unassigned_shards		|	-	|	integer	|	-	|
|	initializing_shards	|	-	|	integer	|	-	|
|	number_of_data_nodes	|	-	|	integer	|	-	|
|	number_of_in_flight_fetch	|	-	|	integer	|	-	|
|	number_of_nodes	|	-	|	integer	|	-	|
|	number_of_pending_tasks		|	-	|	integer	|	-	|
|	relocating_shards	|	-	|	integer	|	-	|
|	status		|	-	|	enum("green","yellow","red")	|	-	|
|	status_code	|	-	|	integer, green = 1, yellow = 2, red = 3	|	-	|
|	task_max_waiting_in_queue_millis		|	-	|	integer	|	-	|
|	timed_out	|	-	|	boolean	|	-	|
|	unassigned_shards	|	-	|	boolean	|	-	|


#### 指标集 `elasticsearch_cluster_health_indices`

前置条件:

* cluster_health = true
* cluster_health_level = "indices"

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|	name	|			|
|	index	|			|

指标

|	指标	|	描述	|	类型	|	单位	|
|	:----:	|	:----:	|	:----:	|	:----:	|
|	active_primary_shards	|	-	|	integer	|	-	|
|	active_shards		|	-	|	integer	|	-	|
|	initializing_shards		|	-	|	integer	|	-	|
|	number_of_replicas	|	-	|	integer	|	-	|
|	number_of_shards		|	-	|	integer	|	-	|
|	relocating_shards	|	-	|	integer	|	-	|
|	status	|	-	|	enum("green","yellow","red")	|	-	|
|	status_code	|	-	|	integer, green = 1, yellow = 2, red = 3	|	-	|
|	unassigned_shards	|	-	|	integer	|	-	|

#### 指标集 `elasticsearch_clusterstats_indices`

前置条件：

* cluster_stats = true

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|cluster_name	||
|node_name	||
|status	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|completion_size_in_bytes|	-	|float	|-|
|count	|-	|float|	-|
|docs_count	|-	|float|	-|
|docs_deleted	|-	|float|	-|
|fielddata_evictions	|-	|float	|-|
|fielddata_memory_size_in_bytes	|-	|float|	-|
|query_cache_cache_count	|-|	float	|-|
|query_cache_cache_size	|-	|float|	-|
|query_cache_evictions	|-	|float|	-|
|query_cache_hit_count	|-	|float|	-|
|query_cache_memory_size_in_bytes	|-	|float|	-|
|query_cache_miss_count	|-	|float|	-|
|query_cache_total_count	|-	|float|	-|
|segments_count	|-	|float	|-|
|segments_doc_values_memory_in_bytes|	-|	float	|-|
|segments_fixed_bit_set_memory_in_bytes|	-	|float	|-|
|segments_index_writer_memory_in_bytes	|-|	float	|-|
segments_max_unsafe_auto_id_timestamp	|-|	float|	-|
|segments_memory_in_bytes	|-	|float	|-|
|segments_norms_memory_in_bytes	|-|	float|	-|
|shards_index_primaries_avg	|-	|float	|-|
|shards_index_primaries_max	|-	|float|	-|
|shards_index_primaries_min	|-	|float|	-|
|shards_index_replication_avg	|-	|float|	-|
|shards_index_replication_max	|-	|float|	-|
|shards_index_replication_min	|-	|float	|-|
|shards_index_shards_avg	|-	|float	|-|
|shards_index_shards_max|	-	|float	|-|
|shards_index_shards_min	|-|	float	|-|
|shards_primaries|	-	|float	|-|
|shards_replication|	-	|float|	-|
|shards_total	|-	|float	|-|
|store_size_in_bytes|	-|	float	|-|

#### 指标集` elasticsearch_clusterstats_nodes`
标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|cluster_name	||
|node_name	||
|status	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|count_coordinating_only|	-	|float	|-|
|count_data	|-	|float|	-|
|count_ingest|	-	|float|	-|
|count_master|	-|	float	|-|
|count_total	|-	|float|	-|
|fs_available_in_bytes	|-	|float	|-|
|fs_free_in_bytes	|-	|float	|-|
|fs_total_in_bytes|	-	|float	|-|
|jvm_max_uptime_in_millis|	-	|float|	-|
|jvm_mem_heap_max_in_bytes|	-|	float|	-|
|jvm_mem_heap_used_in_bytes|	-	|float|	-|
|jvm_threads|	-	|float|	-|
|jvm_versions_0_count	|-	|float|	-|
|jvm_versions_0_version|	-|	string	|-|
|jvm_versions_0_vm_name	|-|	string|	-|
|jvm_versions_0_vm_vendor|	-	|string	|-|
|jvm_versions_0_vm_version	|-	|string	|-|
|network_types_http_types_security4|	-	|float|	-|
|network_types_transport_types_security4|	-	|float	|-|
|os_allocated_processors	|-	|float	|-|
|os_available_processors	|-	|float|	-|
|os_mem_free_in_bytes	|-	|float|	-|
|os_mem_free_percent	|-|	float|	-|
|os_mem_total_in_bytes	|-	|float|	-|
|os_mem_used_in_bytes	|-	|float|	-|
|os_names_0_count	|-	|float|	-|
|os_names_0_name|	-	|float|	-|
|os_pretty_names_0_count	|-|	float|	-|
|os_pretty_names_0_pretty_name|	-	|float|	-|
|process_cpu_percent	|-	|float|	-|
|process_open_file_descriptors_avg|	-|	float|	-|
|process_open_file_descriptors_max|	-	|float|	-|
|process_open_file_descriptors_min|	-|	float|	-|
|versions_0	|-|	string|	-|

#### 指标集 `elasticsearch_transport`

前置条件

* 开启 node_stats 设置


标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name||
	
指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|rx_count	|-|	float|	-|
|rx_size_in_bytes|	-	|float|	-|
|server_open	|-	|float|	-|
|tx_count|	-	|float|	-|
|tx_size_in_bytes|	-	|float	|-|

#### 指标集` elasticsearch_breakers`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|	
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|accounting_estimated_size_in_bytes|	-	|float|	-|
|accounting_limit_size_in_bytes	|-|	float|	-|
|accounting_overhead	|-	|float	|-|
|accounting_tripped	|-	|float|	-|
|fielddata_estimated_size_in_bytes|	-	|float	|-|
|fielddata_limit_size_in_bytes	|-	|float	|-|
|fielddata_overhead|	-|	float	|-|
|fielddata_tripped	|-|	float|	-|
|in_flight_requests_estimated_size_in_bytes	|-	|float	|-|
|in_flight_requests_limit_size_in_bytes	|-	|float|	-|
|in_flight_requests_overhead	|-|	float	|-|
|in_flight_requests_tripped	|-|	float	|-|
|parent_estimated_size_in_bytes	|-|	float	|-|
|parent_limit_size_in_bytes	|-|	float	|-|
|parent_overhead	|-|	float	|-|
|parent_tripped	|-|	float	|-|
|request_estimated_size_in_bytes	|-|	float	|-|
|accounting_estimated_size_in_bytes	|-|	float	|-|
|request_limit_size_in_bytes	|-|	float	|-|
|request_overhead	|-|	float	|-|
|request_tripped	|-	|float	|-|

#### 指标集 `elasticsearch_fs`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|	
|cluster_name||	
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|data_0_available_in_bytes	|-|	float	|-|
|data_0_free_in_bytes	|-|	float	|-|
|data_0_total_in_bytes	|-|	float	|-|
|io_stats_devices_0_operations	|-|	float	|-|
|io_stats_devices_0_read_kilobytes	|-|	float	|-|
|io_stats_devices_0_read_operations	|-|	float	|-|
|io_stats_devices_0_write_kilobytes	|-|	float	|-|
|io_stats_total_write_operations	|-|	float	|-|
|io_stats_devices_0_write_operations	|-|	float	|-|
|io_stats_total_operations	|-|	float	|-|
|io_stats_total_read_kilobytes	|-|	float	|-|
|io_stats_total_read_operations	|-|	float	|-|
|io_stats_total_write_kilobytes	|-|	float	|-|
|timestamp	|-|	float	|-|
|total_available_in_bytes	|-|	float	|-|
|total_free_in_bytes	|-|	float	|-|
|total_total_in_bytes	|-|	float	|-|

#### 指标集 `elasticsearch_http`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|	
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|current_open|	-|	float|	-|
|total_opened	|-|	float	|-|

#### 指标集 `elasticsearch_indices`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|	
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed||	
|node_host	||
|node_id	||
|node_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|completion_size_in_bytes	|-|	float	|-|
|docs_count	|-|	float	|-|
|docs_deleted	|-|	float	|-|
|fielddata_evictions	|-|	float	|-|
|fielddata_memory_size_in_bytes	|-	|float	|-|
|flush_periodic	|-|	float	|-|
|flush_total	|-|	float	|-|
|flush_total_time_in_millis	|-|	float	|-|
|get_current	|-|	float	|-|
|get_exists_time_in_millis	|-|	float	|-|
|get_exists_total	|-|	float|	-|
|get_missing_time_in_millis	|-|	float	|-|
|get_time_in_millis	|-|	float	|-|
|get_total	|-|	float	|-|
|indexing_delete_current	|-|	float	|-|
|indexing_delete_time_in_millis	|-|	float	|-|
|indexing_delete_total	|-|	float	|-|
|indexing_index_current	|-|	float	|-|
|indexing_index_failed	|-|	float	|-|
|indexing_index_time_in_millis	|-|	float	|-|
|indexing_index_total	|-|	float	|-|
|indexing_noop_update_total	|-|	float	|-|
|indexing_throttle_time_in_millis	|-|	float	|-|
|merges_current	|-|	float	|-|
|merges_current_docs	|-|	float	|-|
|merges_current_size_in_bytes	|-|	float	|-|
|merges_total	|-|	float	|-|
|merges_total_auto_throttle_in_bytes	|-|	float	|-|
|merges_total_docs	|-|	float	|-|
|merges_total_size_in_bytes	|-|	float	|-|
|merges_total_stopped_time_in_millis	|-|	float	|-|
|merges_total_throttled_time_in_millis	|-|	float	|-|
|merges_total_time_in_millis	|-|	float	|-|
|query_cache_cache_count	|-|	float	|-|
|query_cache_cache_size|	-|	float	|-|
|query_cache_evictions	|-|	float	|-|
|query_cache_hit_count	|-|	float	|-|
|query_cache_memory_size_in_bytes	|-|	float	|-|
|query_cache_miss_count	|-|	float	|-|
|query_cache_total_count|	-|	float	|-|
|recovery_current_as_source	|-|	float	|-|
|recovery_current_as_target	|-|	float	|-|
|recovery_throttle_time_in_millis|	-|	float	|-|
|refresh_listeners	|-|	float	|-|
|refresh_total	|-|	float	|-|
|refresh_total_time_in_millis|	-|	float	|-|
|request_cache_evictions	|-|	float	|-|
|request_cache_hit_count	|-|	float	|-|
|request_cache_memory_size_in_bytes	|-|	float	|-|
|request_cache_miss_count	|-|	float	|-|
|search_fetch_current	|-|	float	|-|
|search_fetch_time_in_millis	|-|	float	|-|
|search_fetch_total	|-|	float	|-|
|search_open_contexts	|-|	float	|-|
|search_query_current	|-|	float	|-|
|search_query_time_in_millis	|-	|float	|-|
|search_query_total	|-|	float	|-|
|search_scroll_current	|-|	float	|-|
|search_scroll_time_in_millis	|-|	float|	-|
|search_scroll_total	|-|	float	|-|
|search_suggest_current|	-|	float	|-|
|search_suggest_time_in_millis	|-|	float	|-|
|search_suggest_total|	-|	float|	-|
|segments_count	|-|	float	|-|
|segments_doc_values_memory_in_bytes	|-|	float	|-|
|segments_fixed_bit_set_memory_in_bytes	|-|	float	|-|
|segments_index_writer_memory_in_bytes	|-|	float	|-|
|segments_max_unsafe_auto_id_timestamp	|-|	float	|-|
|segments_memory_in_bytes	|-|	float	|-|
|segments_norms_memory_in_bytes	|-|	float	|-|
|segments_points_memory_in_bytes	|-|	float	|-|
|segments_stored_fields_memory_in_bytes	|-|	float	|-|
|segments_term_vectors_memory_in_bytes	|-|	float	|-|
|segments_terms_memory_in_bytes	|-|	float	|-|
|segments_version_map_memory_in_bytes	|-|	float	|-|
|store_size_in_bytes	|-|	float	|-|
|translog_earliest_last_modified_age	|-|	float	|-|
|translog_operations	|-|	float	|-|
|translog_size_in_bytes	|-|	float	|-|
|translog_uncommitted_operations	|-|	float	|-|
|translog_uncommitted_size_in_bytes	|-|	float	|-|
|warmer_current|	-|	float	|-|
|warmer_total	|-|	float	|-|
|warmer_total_time_in_millis	|-	|float	|-|

#### 指标集 `elasticsearch_jvm`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|	
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name||	

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|buffer_pools_direct_count	|-|	float	|-|
|buffer_pools_direct_total_capacity_in_bytes	|-|	float	|-|
|buffer_pools_direct_used_in_bytes	|-|	float	|-|
|buffer_pools_mapped_count	|-|	float	|-|
|buffer_pools_mapped_total_capacity_in_bytes	|-|	float	|-|
|buffer_pools_mapped_used_in_bytes	|-	|float	|-|
|classes_current_loaded_count	|-|	float	|-|
|classes_total_loaded_count	|-|	float	|-|
|classes_total_unloaded_count	|-|	float	|-|
|gc_collectors_old_collection_count	|-|	float	|-|
|gc_collectors_old_collection_time_in_millis	|-	|float	|-|
|gc_collectors_young_collection_count	|-|	float	|-|
|gc_collectors_young_collection_time_in_millis	|-	|float	|-|
|mem_heap_committed_in_bytes	|-|	float	|-|
|mem_heap_max_in_bytes	|-|	float	|-|
|mem_heap_used_in_bytes	|-|	float	|-|
|mem_heap_used_percent	|-|	float	|-|
|mem_non_heap_committed_in_bytes	|-|	float	|-|
|mem_non_heap_used_in_bytes	|-	|float	|-|
|mem_pools_old_max_in_bytes	|-|	float	|-|
|mem_pools_old_peak_max_in_bytes	|-|	float	|-|
|mem_pools_old_peak_used_in_bytes|	-|	float	|-|
|mem_pools_old_used_in_bytes	|-|	float	|-|
|mem_pools_survivor_max_in_bytes	|-|	float	|-|
|mem_pools_survivor_peak_max_in_bytes	|-|	float	|-|
|mem_pools_survivor_peak_used_in_bytes	|-|	float	|-|
|mem_pools_survivor_used_in_bytes	|-|	float	|-|
|mem_pools_young_max_in_bytes	|-|	float	|-|
|mem_pools_young_peak_max_in_bytes	|-|	float	|-|
|mem_pools_young_peak_used_in_bytes	|-|	float	|-|
|mem_pools_young_used_in_bytes	|-|	float	|-|
|threads_count	|-|	float	|-|
|threads_peak_count	|-|	float	|-|
|timestamp	|-|	float	|-|
|uptime_in_millis	|-|	float	|-|

#### 指标集 `elasticsearch_os`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|	
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|cgroup_cpu_cfs_period_micros	|-|	float	|-|
|cgroup_cpu_cfs_quota_micros	|-|	float	|-|
|cgroup_cpu_stat_number_of_elapsed_periods	|-|	float	|-|
|cgroup_cpu_stat_number_of_times_throttled	|-|	float	|-|
|cgroup_cpu_stat_time_throttled_nanos	|-	|float|	-|
|cgroup_cpuacct_usage_nanos	|-	|float	|-|
|cpu_load_average_15m	|-|	float	|-|
|cpu_load_average_1m	|-|	float	|-|
|cpu_load_average_5m	|-|	float	|-|
|cpu_percent	|-	|float	|-|
|mem_free_in_bytes	|-|	float	|-|
|mem_free_percent	|-|	float	|-|
|mem_total_in_bytes	|-|	float	|-|
|mem_used_in_bytes	|-|	float	|-|
|mem_used_percent	|-|	float	|-|
|swap_free_in_bytes	|-|	float	|-|
|swap_total_in_bytes	|-|	float	|-|
|swap_used_in_bytes	|-|	float	|-|
|timestamp	|-|	float	|-|

#### 指标集 `elasticsearch_process`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|cpu_percent	|-|	float	|-|
|cpu_total_in_millis	|-|	float	|-|
|max_file_descriptors	|-|	float	|-|
|mem_total_virtual_in_bytes	|-|	float	|-|
|open_file_descriptors	|-|	float|	-|
|timestamp	|-|	float	|-|

#### 指标集 `elasticsearch_thread_pool`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|cluster_name	||
|node_attribute_ml.enabled	||
|node_attribute_ml.machine_memory	||
|node_attribute_ml.max_open_jobs	||
|node_attribute_xpack.installed	||
|node_host	||
|node_id	||
|node_name	||

指标名

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|analyze_active	|-|	float	|-|
|analyze_completed	|-|	float	|-|
|analyze_largest	|-|	float	|-|
|analyze_queue	|-|	float	|-|
|analyze_rejected	|-|	float	|-|
|analyze_threads	|-|	float	|-|
|ccr_active	|-|	float	|-|
|ccr_completed	|-|	float	|-|
|ccr_largest	|-|	float	|-|
|ccr_queue	|-|	float	|-|
|ccr_rejected	|-|	float	|-|
|ccr_threads	|-|	float	|-|
|fetch_shard_started_active	|-|	float	|-|
|fetch_shard_started_completed	|-|	float	|-|
|fetch_shard_started_largest	|-|	float	|-|
|force_merge_queue	|-|	float	|-|
|force_merge_rejected	|-|	float	|-|
|force_merge_threads	|-|	float	|-|
|generic_active	|-|	float	|-|
|generic_completed	|-|	float	|-|
|generic_largest	|-|	float	|-|
|generic_queue	|-	|float	|-|
|generic_rejected	|-|	float	|-|
|generic_threads	|-|	float	|-|
|get_active|	-	|float|	-|
|get_completed	|-|	float	|-|
|get_largest	|-|	float	|-|
|get_queue	|-|	float	|-|
|get_rejected	|-|	float	|-|
|get_threads	|-|	float	|-|
|index_active	|-|	float	|-|
|index_completed	|-|	float	|-|
|index_largest	|-|	float	|-|
|index_queue	|-|	float	|-|
|index_rejected	|-|	float	|-|
|index_threads	|-|	float	|-|
|listener_active	|-|	float	|-|
|listener_completed	|-|	float	|-|
|listener_largest	|-|	float	|-|
|listener_queue	|-|	float	|-|
|listener_rejected	|-|	float	|-|
|listener_threads	|-|	float	|-|
|management_active	|-|	float	|-|
|management_completed	|-|	float	|-|
|management_largest	|-|	float	|-|
|management_queue	|-|	float	|-|
|management_rejected	|-|	float	|-|
|management_threads	|-|	float	|-|
|ml_autodetect_active	|-|	float	|-|
|ml_autodetect_completed	|-|	float	|-|
|ml_autodetect_largest	|-|	float	|-|
|ml_autodetect_queue	|-|	float	|-|
|ml_autodetect_rejected	|-|	float	|-|
|ml_autodetect_threads	|-|	float	|-|
|ml_datafeed_active	|-|	float	|-|
|ml_datafeed_completed	|-|	float	|-|
|ml_datafeed_largest	|-|	float	|-|
|ml_datafeed_queue	|-|	float	|-|
|ml_datafeed_rejected	|-|	float	|-|
|ml_datafeed_threads	|-|	float	|-|
|ml_utility_active	|-|	float	|-|
|ml_utility_completed	|-|	float	|-|
|ml_utility_largest	|-|	float	|-|
|ml_utility_queue	|-|	float	|-|
|ml_utility_rejected	|-|	float	|-|
|ml_utility_threads	|-|	float	|-|
|refresh_active	|-|	float	|-|
|refresh_completed	|-|	float	|-|
|refresh_largest	|-|	float	|-|
|refresh_queue	|-|	float	|-|
|refresh_rejected	|-|	float	|-|
|refresh_threads	|-|	float	|-|
|rollup_indexing_active	|-|	float	|-|
|rollup_indexing_completed	|-|	float	|-|
|rollup_indexing_largest	|-|	float	|-|
|rollup_indexing_queue	|-|	float	|-|
|rollup_indexing_rejected	|-|	float	|-|
|rollup_indexing_threads	|-|	float	|-|
|search_active	|-|	float	|-|
|search_completed	|-|	float	|-|
|search_largest	|-|	float	|-|
|search_queue	|-|	float	|-|
|search_rejected	|-|	float	|-|
|search_threads	|-|	float	|-|
|search_throttled_active	|-|	float	|-|
|search_throttled_completed	|-|	float	|-|
|search_throttled_largest	|-|	float	|-|
|search_throttled_queue	|-|	float	|-|
|rollup_indexing_completed	|-|	float	|-|
|search_throttled_rejected	|-|	float	|-|
|search_throttled_threads	|-|	float	|-|
|security-token-key_active	|-|	float	|-|
|security-token-key_completed	|-|	float	|-|
|security-token-key_largest	|-|	float	|-|
|security-token-key_queue	|-|	float	|-|
|security-token-key_rejected	|-|	float	|-|
|security-token-key_threads	|-|	float	|-|
|snapshot_active	|-|	float	|-|
|snapshot_completed	|-|	float	|-|
|snapshot_largest	|-|	float	|-|
|snapshot_queue	|-|	float	|-|
|snapshot_rejected	|-|	float	|-|
|snapshot_threads	|-|	float	|-|
|warmer_active	|-|	float	|-|
|warmer_completed	|-|	float	|-|
|warmer_largest	|-|	float	|-|
|warmer_queue	|-|	float	|-|
|warmer_rejected	|-|	float	|-|
|warmer_threads	|-|	float	|-|
|watcher_active	|-|	float	|-|
|watcher_completed	|-|	float	|-|
|watcher_queue	|-|	float	|-|
|watcher_rejected	|-|	float	|-|
|watcher_threads	|-|	float	|-|
|write_active	|-	|float	|-|
|write_completed	|-|	float	|-|
|write_largest|	-|	float	|-|
|write_queue	|-|	float	|-|
|write_rejected	|-|	float	|-|
|write_threads	|-|	float	|-|

#### 指标集 `elasticsearch_indices_stats_(primaries|total)`

前置条件

* 开启 indices_stats 设置


标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|	index_name	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|completion_size_in_bytes	|-	|float	|-|
|docs_count	|-|	float	|-|
|docs_deleted|	-|	float	|-|
|fielddata_evictions	|-	|float	|-|
|fielddata_memory_size_in_bytes	|-|	float	|-|
|flush_periodic	|-|	float	|-|
|flush_total|	-|	float	|-|
|flush_total_time_in_millis	|-	|float	|-|
|get_current	|-	|float	|-|
|get_exists_time_in_millis	|-	|float|	-|
|get_exists_total	|-|	float|	-|
|get_missing_time_in_millis	|-	|float|	-|
|get_missing_total	|-|	float	|-|
|get_time_in_millis	|-|	float	|-|
|get_total	|-|	float	|-|
|indexing_delete_current	|-|	float	|-|
|indexing_delete_time_in_millis	|-|	float	|-|
|indexing_delete_total	|-|	float	|-|
|indexing_index_current	|-|	float	|-|
|indexing_index_failed	|-|	float	|-|
|indexing_index_time_in_millis	|-	|float	|-|
|indexing_index_total	|-|	float	|-|
|indexing_is_throttled|	-|	float	|-|
|indexing_noop_update_total	|-|	float	|-|
|indexing_throttle_time_in_millis	|-|	float	|-|
|merges_current	|-|	float	|-|
|merges_current_docs	|-	|float	|-|
|merges_current_size_in_bytes	|-|	float	|-|
|merges_total	|-|	float	|-|
|merges_total_auto_throttle_in_bytes	|-|	float	|-|
|merges_total_docs	|-|	float	|-|
|merges_total_size_in_bytes	|-|	float	|-|
|merges_total_stopped_time_in_millis	|-|	float	|-|
|merges_total_throttled_time_in_millis	|-|	float	|-|
|merges_total_time_in_millis	|-|	float	|-|
|query_cache_cache_count	|-|	float	|-|
|query_cache_cache_size	|-|	float	|-|
|active_primary_shards	|-|	float	|-|
|query_cache_memory_size_in_bytes	|-|	float	|-|
|query_cache_hit_count	|-|	float	|-|
|query_cache_miss_count|	-|	float	|-|
|query_cache_total_count	|-|	float	|-|
|recovery_current_as_source	|-|	float	|-|
|recovery_current_as_target|	-|	float	|-|
|recovery_throttle_time_in_millis	|-|	float	|-|
|refresh_external_total	|-|	float	|-|
|refresh_external_total_time_in_millis	|-|	float	|-|
|refresh_listeners	|-|	float	|-|
|refresh_total	|-	|float	|-|
|refresh_total_time_in_millis	|-|	float	|-|
|request_cache_evictions|	-|	float	|-|
|request_cache_hit_count|	-|	float	|-|
|request_cache_memory_size_in_bytes	|-|	float	|-|
|request_cache_miss_count	|-	|float	|-|
|search_fetch_current	|-|	float	|-|
|search_fetch_time_in_millis	|-|	float|	-|
|search_fetch_total	|-|	float	|-|
|search_open_contexts	|-	|float|	-|
|search_query_current	|-	|float	|-|
|search_query_time_in_millis	|-	|float	|-|
|search_query_total|	-	|float	|-|
|search_scroll_current|	-	|float	|-|
|search_scroll_time_in_millis	|-|	float	|-|
|search_scroll_total	|-|	float	|-|
|search_suggest_current	|-|	float	|-|
|search_suggest_time_in_millis	|-|	float	|-|
|search_suggest_total	|-|	float	|-|
|segments_count	|-|	float	|-|
|segments_doc_values_memory_in_bytes	|-|	float	|-|
|segments_fixed_bit_set_memory_in_bytes	|-|	float	|-|
|segments_index_writer_memory_in_bytes	|-|	float	|-|
|segments_max_unsafe_auto_id_timestamp	|-|	float	|-|
|segments_memory_in_bytes	|-|	float	|-|
|segments_norms_memory_in_bytes	|-|	float	|-|
|segments_points_memory_in_bytes	|-|	float	|-|
|segments_stored_fields_memory_in_bytes	|-|	float	|-|
|segments_term_vectors_memory_in_bytes	|-|	float	|-|
|segments_terms_memory_in_bytes	|-|	float	|-|
|segments_version_map_memory_in_bytes	|-|	float	|-|
|store_size_in_bytes	|-|	float	|-|
|translog_earliest_last_modified_age	|-|	float	|-|
|translog_operations	|-|	float	|-|
|translog_size_in_bytes	|-|	float	|-|
|translog_uncommitted_operations	|-|	float	|-|
|translog_uncommitted_size_in_bytes	|-|	float	|-|
|warmer_current	|-	|float	|-|
|warmer_total	|-	|float	|-|
|warmer_total_time_in_millis	|-|	float	|-|

#### 指标集 `elasticsearch_indices_stats_shards_total`

前置条件

* 开启 shards_stats 设置


标签

* 无

指标

|指标	|描述	|类型	|单位|Tag|
|	:----:	|	:----:	|	:----:	|	:----:	|:----:|
|failed|	-|	float	|-|	-|
|successful	|-|	float	|-	|-|
|total	|-|	float|	-|	-|

#### 指标集 `elasticsearch_indices_stats_shards`

标签

|	标签名	|	描述	|
|	:----:	|	:----:	|
|index_name	||
|index_name	||
|node_name	||
|shard_name	||
|type	||

指标

|指标	|描述	|类型	|单位|
|	:----:	|	:----:	|	:----:	|	:----:	|
|commit_generation	|-|	float	|-|
|commit_num_docs	|-|	float	|-|
|completion_size_in_bytes	|-|	float	|-|
|docs_count	|-|	float	|-|
|docs_deleted	|-|	float	|-|
|fielddata_evictions	|-|	float	|-|
|fielddata_memory_size_in_bytes	|-|	float	|-|
|flush_periodic	|-|	float	|-|
|flush_total	|-|	float	|-|
|flush_total_time_in_millis	|-|	float	|-|
|get_current	|-|	float	|-|
|get_exists_time_in_millis	|-|	float	|-|
|get_exists_total	|-	|float	|-|
|get_missing_time_in_millis	|-|	float	|-|
|get_missing_total	|-|	float	|-|
|get_time_in_millis	|-|	float	|-|
|get_total	|-|	float	|-|
|indexing_delete_current	|-|	float	|-|
|indexing_delete_time_in_millis	|-|	float	|-|
|indexing_delete_total	|-|	float	|-|
|indexing_index_current|	-|	float	|-|
|indexing_index_failed	|-|	float	|-|
|indexing_index_time_in_millis	|-|	float	|-|
|indexing_index_total	|-|	float	|-|
|indexing_is_throttled	|-|	float	|-|
|indexing_noop_update_total	|-|	float	|-|
|indexing_throttle_time_in_millis	|-|	float	|-|
|merges_current	|-|	float	|-|
|merges_current_docs	|-|	float	|-|
|merges_current_size_in_bytes|	-|	float	|-|
|merges_total	|-|	float	|-|
|merges_total_auto_throttle_in_bytes|	-|	float	|-|
|merges_total_docs	|-|	float	|-|
|merges_total_size_in_bytes	|-|	float	|-|
|merges_total_stopped_time_in_millis	|-|	float	|-|
|merges_total_throttled_time_in_millis	|-|	float	|-|
|merges_total_time_in_millis	|-|	float	|-|
|query_cache_cache_count	|-|	float	|-|
|query_cache_cache_size|	-	|float	|-|
|query_cache_evictions	|-|	float	|-|
|query_cache_hit_count	|-|	float	|-|
|query_cache_memory_size_in_bytes	|-|	float	|-|
|query_cache_miss_count	|-|	float	|-|
|query_cache_total_count	|-|	float	|-|
|recovery_current_as_source	|-	|float	|-|
|recovery_current_as_target	|-	|float	|-|
|recovery_throttle_time_in_millis	|-|	float	|-|
|refresh_external_total	|-|	float	|-|
|refresh_external_total_time_in_millis	|-|	float	|-|
|refresh_listeners	|-|	float	|-|
|refresh_total	|-|	float	|-|
|refresh_total_time_in_millis	|-|	float	|-|
|request_cache_evictions	|-|	float	|-|
|request_cache_hit_count	|-	|float	|-|
|request_cache_memory_size_in_bytes	|-	|float	|-|
|request_cache_miss_count	|-|	float	|-|
|retention_leases_primary_term	|-|	float	|-|
|retention_leases_version	|-|	float	|-|
|routing_state	|-|	int	|-|
|search_fetch_current	|-|	float	|-|
|search_fetch_current	|-|	float	|-|
|search_fetch_total	|-|	float	|-|
|search_open_contexts	|-|	float	|-|
|search_query_current	|-|	float	|-|
|search_query_time_in_millis	|-|	float	|-|
|search_query_total	|-	|float	|-|
|search_scroll_current|	-|	float	|-|
|search_scroll_time_in_millis	|-|	float|	-|
|search_scroll_total	|-|	float	|-|
|search_suggest_current	|-|	float	|-|
|search_suggest_time_in_millis	|-	|float	|-|
|search_suggest_total	|-|	float	|-|
|segments_count	|-|	float	|-|
|segments_doc_values_memory_in_bytes	|-|	float	|-|
|segments_fixed_bit_set_memory_in_bytes	|-|	float	|-|
|segments_index_writer_memory_in_bytes	|-|	float	|-|
|segments_max_unsafe_auto_id_timestamp	|-|	float	|-|
|segments_memory_in_bytes	|-|	float	|-|
|segments_norms_memory_in_bytes	|-|	float	|-|
|segments_points_memory_in_bytes	|-|	float	|-|
|segments_stored_fields_memory_in_bytes	|-|	float	|-|
|segments_term_vectors_memory_in_bytes	|-|	float	|-|
|segments_terms_memory_in_bytes	|-|	float	|-|
|segments_version_map_memory_in_bytes	|-|	float	|-|
|seq_no_global_checkpoint	|-|	float	|-|
|seq_no_local_checkpoint	|-|	float	|-|
|seq_no_max_seq_no	|-|	float	|-|
|shard_path_is_custom_data_path	|-|	float	|-|
|store_size_in_bytes	|-|	float	|-|
|translog_earliest_last_modified_age	|-|	float	|-|
|translog_operations	|-|	float	|-|
|translog_size_in_bytes	|-|	float	|-|
|translog_uncommitted_operations	|-|	float	|-|
|translog_uncommitted_size_in_bytes	|-|	float	|-|
|warmer_current	|-|	float	|-|
|warmer_total	|-|	float	|-|
|warmer_total_time_in_millis	|-|	float	|-|

### 概览
	
![ElasticSearch监控场景](./img/ElasticSearch监控场景.png)
	