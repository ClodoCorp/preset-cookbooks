
require File.join(File.dirname(File.dirname(File.dirname(__FILE__))), '/system/libraries/system.rb')

module Config_mysql
   R_MEM_MAX_USE_P		= [1,90]
   R_MEM_USE_P			= [1,90]
   R_KEY_BUFFER_SIZE		= [8388608,536870912]
   R_SORT_BUFFER_SIZE		= [2097152,33554432]
   R_JOIN_BUFFER_SIZE		= [2097152,33554432]
   R_READ_BUFFER_SIZE		= [2097152,33554432]
   R_READ_RND_BUFFER_SIZE	= [2097152,33554432]
   R_QUERY_CACHE_LIMIT		= [1048576,33554432]
   R_QUERY_CACHE_SIZE		= [8388608,536870912]
   R_TABLE_OPEN_CACHE		= [32,10000]
   R_TABLE_DEFINITION_CACHE	= [32,10000]
   R_THREAD_STACK		= [262144,524288]
   R_THREAD_CACHE_SIZE		= [10,2000]
   R_MAX_ALLOWED_PACKET		= [16777216,33554432]
   R_MAX_HEAP_TABLE_SIZE	= [33554432,10737418240]
   R_TMP_TABLE_SIZE		= [16777216,536870912]
   R_MYISAM_SORT_BUFFER_SIZE	= [16777216,536870912]
   R_MAX_CONNECTIONS		= [10,5000]
   R_INNODB_LOG_FILE_SIZE	= [67108864,1073741824]
   R_INNODB_LOG_BUFFER_SIZE	= [8388608,536870912]
   R_INNODB_BUFFER_POOL_SIZE	= [58720256,10737418240]
   R_INNODB_ADDITIONAL_MEM_POOL_SIZE	= [2097152,67108864]
   R_INNODB_THREAD_CONCURRENCY		= [2,200]

   attr :mem_max_use_p
   attr :mem_use_p
   attr :mem_max_use, true
   attr :mem_use_lim, true
   attr :key_buffer_size, true
   attr :sort_buffer_size, true
   attr :join_buffer_size, true
   attr :read_buffer_size, true
   attr :read_rnd_buffer_size, true
   attr :query_cache_limit, true
   attr :query_cache_size, true
   attr :table_open_cache, true
   attr :table_definition_cache, true
   attr :thread_stack, true
   attr :thread_cache_size, true
   attr :max_allowed_packet, true
   attr :max_heap_table_size, true
   attr :tmp_table_size, true
   attr :myisam_sort_buffer_size, true
   attr :max_connections, true
   attr :innodb_log_file_size, true
   attr :innodb_log_buffer_size, true
   attr :innodb_buffer_pool_size, true
   attr :innodb_additional_mem_pool_size, true
   attr :innodb_thread_concurrency, true
   attr :mem_usage, true

   def initialize(
		  mem_max_use_p,
		  mem_use_p,
		  query_cache_limit 	= 1048576,
		  query_cache_size 	= 16777216,
		  table_open_cache 	= 32,
		  table_definition_cache = 32,
		  thread_cache_size 	= 10,
		  max_allowed_packet 	= 16777216,
		  max_heap_table_size 	= 33554432,
		  tmp_table_size 	= 16777216,
		  myisam_sort_buffer_size = 16777216,
		  innodb_log_file_size 	= 67108864
		  )

      si = System.new()
      @mem_max_use_p	= si.check_range(mem_max_use_p, R_MEM_MAX_USE_P)
      @mem_use_p 	= si.check_range(mem_use_p, R_MEM_USE_P)
      
      @mem_max_use = (si.mem_max()/100*@mem_max_use_p)
      @mem_use_lim = (@mem_max_use/100*@mem_use_p)
      @key_buffer_size 		= si.check_range((@mem_use_lim/100*3.5).round.to_i, R_KEY_BUFFER_SIZE)
      @sort_buffer_size 	= si.check_range((@mem_use_lim/100*1.1).round.to_i, R_SORT_BUFFER_SIZE)
      @join_buffer_size 	= si.check_range((@mem_use_lim/100*1.1).round.to_i, R_JOIN_BUFFER_SIZE)
      @read_buffer_size 	= si.check_range((@mem_use_lim/100*1.1).round.to_i, R_READ_BUFFER_SIZE)
      @read_rnd_buffer_size 	= si.check_range((@mem_use_lim/100*1.1).round.to_i, R_READ_RND_BUFFER_SIZE)
      @query_cache_limit 	= si.check_range(query_cache_limit, R_QUERY_CACHE_LIMIT)
      @query_cache_size 	= si.check_range(query_cache_size, R_QUERY_CACHE_SIZE)
      @table_open_cache 	= si.check_range(table_open_cache, R_TABLE_OPEN_CACHE)
      @table_definition_cache 	= si.check_range(table_definition_cache, R_TABLE_DEFINITION_CACHE)
      @thread_stack 		= si.check_range((@mem_use_lim/100*0.0025).round.to_i, R_THREAD_STACK)
      @thread_cache_size 	= si.check_range(thread_cache_size, R_THREAD_CACHE_SIZE)
      @max_allowed_packet 	= si.check_range(max_allowed_packet, R_MAX_ALLOWED_PACKET)
      @max_heap_table_size 	= si.check_range(max_heap_table_size, R_MAX_HEAP_TABLE_SIZE)
      @tmp_table_size 		= si.check_range(tmp_table_size, R_TMP_TABLE_SIZE)
      @myisam_sort_buffer_size 	= si.check_range(myisam_sort_buffer_size, R_MYISAM_SORT_BUFFER_SIZE)
      @innodb_log_file_size 	= si.check_range(innodb_log_file_size, R_INNODB_LOG_FILE_SIZE)
      @innodb_log_buffer_size 	= si.check_range((@mem_use_lim/100*0.2).round.to_i, R_INNODB_LOG_BUFFER_SIZE)
      @innodb_buffer_pool_size 	= si.check_range((@mem_use_lim/100*20).round.to_i, R_INNODB_BUFFER_POOL_SIZE)
      @innodb_additional_mem_pool_size 	= si.check_range((@mem_use_lim/100*0.2).round.to_i, R_INNODB_ADDITIONAL_MEM_POOL_SIZE)
      @innodb_thread_concurrency 	= si.check_range((si.cpus*2+1).round.to_i, R_INNODB_THREAD_CONCURRENCY)
      @max_connections  = si.check_range(((@mem_max_use - (@key_buffer_size + @innodb_log_buffer_size + @innodb_buffer_pool_size)
						) / (@sort_buffer_size + @join_buffer_size + @read_buffer_size + 
						@read_rnd_buffer_size + @thread_stack)).round.to_i, R_MAX_CONNECTIONS)      
      @mem_usage = (@key_buffer_size + @innodb_log_buffer_size + @innodb_buffer_pool_size) + 
				    ((@sort_buffer_size + @join_buffer_size + @read_buffer_size + @read_rnd_buffer_size + 
				    @thread_stack) * @max_connections)
#      puts("debug #{@mem_max_use} #{@key_buffer_size} #{@innodb_log_buffer_size} #{@innodb_buffer_pool_size} #{@sort_buffer_size} #{@join_buffer_size} #{@read_buffer_size} #{@read_rnd_buffer_size} #{@thread_stack} #{@max_connections}")
      si = nil
   end

end
