
require File.join(File.dirname(File.dirname(File.dirname(__FILE__))), '/system/libraries/system.rb')

module Config_apache2
   R_MEM_MAX_USE_P		= [1,90]
   R_MEM_USE_P			= [1,90]
   R_START_SERVERS		= [2,100]
   R_MIN_SPARE_SERVERS		= [2,50]
   R_MAX_SPARE_SERVERS		= [2,100]
   R_SERVER_LIMIT		= [2,256]
   R_MAX_CLIENTS		= [2,256]
   R_MAX_REQUESTS_PER_CHILD	= [256, 1000]
   attr :mem_max_use_p
   attr :mem_use_p
   attr :instance_size
   attr :start_servers
   attr :min_spare_servers
   attr :max_spare_servers
   attr :server_limit
   attr :max_clients
   attr :max_requests_per_child

   def initialize(
		  mem_max_use_p,
		  mem_use_p,
		  instance_size,
		  start_servers 	= 2,
		  min_spare_servers 	= 2,
		  max_spare_servers 	= 5,
		  server_limit		= 100,
		  max_clients		= 100,
		  max_requests_per_child = 1000
		  )

      si = System.new()
      @mem_max_use_p	= si.check_range(mem_max_use_p, R_MEM_MAX_USE_P)
      @mem_use_p 	= si.check_range(mem_use_p, R_MEM_USE_P)

      @mem_max_use = (si.mem_max()/100*@mem_max_use_p)
      @mem_use_lim = (@mem_max_use/100*@mem_use_p)
      @start_servers		= si.check_range((@mem_use_lim/instance_size).round.to_i, R_START_SERVERS)
      @min_spare_servers	= si.check_range((@mem_use_lim/instance_size).round.to_i, R_MIN_SPARE_SERVERS)
      @max_spare_servers	= si.check_range((@mem_use_lim/instance_size).round.to_i, R_MAX_SPARE_SERVERS)
      si = nil
   end

end
