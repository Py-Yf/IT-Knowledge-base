# Elasticsearch 使用

### 查询所有索引：
	curl - XGET http://127.0.0.1:9200/_cat/indices?v

### 删除索引
	curl - XDELETE http://dv7:9200/corp-data-v5

### 获取mapping
	GET http: //dv7:9200/corp-data/_mapping/corp-type


### 别名

	POST http: //dv7:9200/_aliases
	{
	    "actions": [{
	            "add": {
	                "index": "corp-data-v5",
	                "alias": "corp-data"
	            }
	        }
	    ]
	}

### 查看分词情况

	GET http: //dv7:9200/corp-data/_analyze?	pretty&analyzer=ik_smart&text=公司

### 搜索

	POST http: //dv7:9200/corp-data/_search?pretty
	    1)指定字段{
	        "query": {
	            "match": {
	                "name": "公司"
	            }
	        }
	    }
	    2)搜索全部{
	        "query": {
	            "match": {
	                "_all": "公司"
	            }
	        }
	    }
	
	    3)搜索返回高亮{
	        "query": {
	            "match": {
	                "name": "公司"
	            }
	        },
	        "highlight": {
	            "pre_tags": ["<tag1>", "<tag2>"],
	            "post_tags": ["</tag1>", "</tag2>"],
	            "fields": {
	                "name": {}
	            }
	        }

### 全文搜索
	GET http: //dv7:9200/corp-data/_search?q='公司'

### 新建索引和mapping

	PUT http: //dv7:9200/test-index5
	POST http: //dv7:9200/test-index5/fulltext5/_mapping
	{
	    "properties": {
	        "content": {
	            "type": "text",
	            "analyzer": "ik_max_word",
	            "search_analyzer": "ik_max_word"
	        }
	    }
	}

### 添加记录

	POST http: //dv7:9200/test-index5/fulltext5/1
	{
	    "content": "事物的两面性"
	}

### 时间聚合查询

	ES默认会将时间戳认为是UTC时间，所以时间聚和的时候要指定time_zone，否则会不准确（默认 + 8h）
	long字段不支持time_zone,用offset代替
		
	POST http: //dv7:9200/corp-data/_search
	{
	    "size": 0,
	    "aggs": {
	        "days_count": {
	            "date_histogram": {
	                "field": "updatetime",
	                "interval": "day",
	                "offset": "-8h",
	                "format": "yyyy-MM-dd"
	            }
	        }
	    }
	}

### 时间范围查询

	POST http: //dv7:9200/corp-data/_search
	{
	    "query": {
	        "constant_score": {
	            "filter": {
	                "range": {
	                    "updatetime": {
	                        "gte": 1519833600000,
	                        "lt": 1619862400000
	                    }
	                }
	            }
	        }
	    }
	}

### bool查询

	POST http: //dv7:9200/corp-data/_search
	{
	    "query": {
	        "bool": {
	            "must": [{
	                    "term": {
	                        "level": "2"
	                    }
	                }
	            ],
	            "must_not": [{
	                    "term": {
	                        "code": ""
	                    }
	                }
	            ],
	            "must": [{
	                    "term": {
	                        "reg_num": ""
	                    }
	                }
	            ]
	        }
	    }
	}

### bool + 聚合查询

	POST http: //dv7:9200/corp-data/_search
	{
	    "query": {
	        "bool": {
	            "must_not": [{
	                    "term": {
	                        "founded_date": ""
	                    }
	                }
	            ]
	        }
	    },
	    "size": 0,
	    "aggs": {
	        "data_level": {
	            "terms": {
	                "field": "level"
	            }
	        }
	    }
	}

### 设置最大返回记录数

	PUT http: //dv7:9200/corp-data/_settings
	{
	    "index": {
	        "max_result_window": "50000000"
	    }
	}

### 更新所有索引参数

	curl - XPUT 'http://localhost:9200/_all/_settings?preserve_existing=true' - d '{
	"index.cache.field.expire" : "10m",
	"index.cache.field.max_size" : "50000",
	"index.cache.field.type" : "soft"
	}'