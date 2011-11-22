# Cookbook Name:: cl_mysql
# Recipe:: server

# TODO
# install/configure cgroups				- in progress
#	add class (mix module) 				- done
#	read databag (parce base params per host)	- done
#	set params for mysql instance			- done
#	set params for cgroups template			- in progress
#	
# install/configure pacemaker
# ...


class Chef::Recipe::MySQL_Instance 	# add class 
  include MySQL_Instance 		# mix module mysql_lnstance.rb from libraries
end

def get_instances_from_databag(databag)
   dbg = data_bag(databag)
   dbg.each do |id|
      item = data_bag_item('cl_mysql', id)
      if item['host'] == node['fqdn']
	 if item['instances'].is_a?(Hash)
	    return item['instances']
	 end
      end	       
   end
end

def retvar(val, vdef)
   if (defined?(val)).nil?
      vdef = val
   else
      val =  vdef
   end
   return val
end

def set_vars(value)
   if ( node['cgroup'].to_i == 1 )
      $cgroup_max_memory	= value['cgroup_max_memory']
      $max_memory		= value['max_memory']
   else
      $cgroup_max_memory	= value['cgroup_max_memory']
      $max_memory		= value['cgroup_max_memory']      
   end

   mi = Chef::Recipe::MySQL_Instance.new($cgroup_max_memory, $max_memory)

   node.default['cl_mysql']['prefix']		= value['name']
   node.default['cl_mysql']['data_dir']		= value['ldir']
   node.default['cl_mysql']['user']		= value['user']
   node.default['cl_mysql']['group']		= value['group']
   node.default['cl_mysql']['socket']		= value['socket']
   node.default['cl_mysql']['pid_file']		= value['pid_file']
   node.default['cl_mysql']['bind_address']	= value['bind_address']
   node.default['cl_mysql']['port']		= value['port']
   node.default['cl_mysql']['replica']['server_id']		= value['server_id']
   node.default['cl_mysql']['tunable']['slow_query_log_file']	= value['slow_query_log_file']
   node.default['cl_mysql']['mysqld_safe']['log-error']	= value['log-error']

   node.default['cl_mysql']['tunable']['key_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['key_buffer_size'], mi.key_buffer_size)
   node.default['cl_mysql']['tunable']['sort_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['sort_buffer_size'], mi.sort_buffer_size)
   node.default['cl_mysql']['tunable']['join_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['join_buffer_size'], mi.join_buffer_size)	    
   node.default['cl_mysql']['tunable']['read_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['read_buffer_size'], mi.read_buffer_size)	    
   node.default['cl_mysql']['tunable']['read_rnd_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['read_rnd_buffer_size'], mi.read_rnd_buffer_size)
   node.default['cl_mysql']['tunable']['query_cache_limit'] = retvar(node.default['cl_mysql']['tunable']['query_cache_limit'], mi.query_cache_limit)
   node.default['cl_mysql']['tunable']['query_cache_size'] = retvar(node.default['cl_mysql']['tunable']['query_cache_size'], mi.query_cache_size)
   node.default['cl_mysql']['tunable']['table_open_cache'] = retvar(node.default['cl_mysql']['tunable']['table_open_cache'], mi.table_open_cache)
   node.default['cl_mysql']['tunable']['table_definition_cache'] = retvar(node.default['cl_mysql']['tunable']['table_definition_cache'], mi.table_definition_cache)
   node.default['cl_mysql']['tunable']['thread_stack'] = retvar(node.default['cl_mysql']['tunable']['thread_stack'], mi.thread_stack)
   node.default['cl_mysql']['tunable']['thread_cache_size'] = retvar(node.default['cl_mysql']['tunable']['thread_cache_size'], mi.thread_cache_size)
   node.default['cl_mysql']['tunable']['max_allowed_packet'] = retvar(node.default['cl_mysql']['tunable']['max_allowed_packet'], mi.max_allowed_packet)
   node.default['cl_mysql']['tunable']['max_heap_table_size'] = retvar(node.default['cl_mysql']['tunable']['max_heap_table_size'], mi.max_heap_table_size)
   node.default['cl_mysql']['tunable']['tmp_table_size'] = retvar(node.default['cl_mysql']['tunable']['tmp_table_size'], mi.tmp_table_size)
   node.default['cl_mysql']['tunable']['myisam_sort_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['myisam_sort_buffer_size'], mi.myisam_sort_buffer_size)	    	    	    	    	    	    	    	    
   node.default['cl_mysql']['tunable']['innodb_log_file_size'] = retvar(node.default['cl_mysql']['tunable']['innodb_log_file_size'], mi.innodb_log_file_size)
   node.default['cl_mysql']['tunable']['innodb_log_buffer_size'] = retvar(node.default['cl_mysql']['tunable']['innodb_log_buffer_size'], mi.innodb_log_buffer_size)
   node.default['cl_mysql']['tunable']['innodb_buffer_pool_size'] = retvar(node.default['cl_mysql']['tunable']['innodb_buffer_pool_size'], mi.innodb_buffer_pool_size)
   node.default['cl_mysql']['tunable']['innodb_additional_mem_pool_size'] = retvar(node.default['cl_mysql']['tunable']['innodb_additional_mem_pool_size'], mi.innodb_additional_mem_pool_size)
   node.default['cl_mysql']['tunable']['innodb_thread_concurrency'] = retvar(node.default['cl_mysql']['tunable']['innodb_thread_concurrency'], mi.innodb_thread_concurrency)
   node.default['cl_mysql']['tunable']['max_connections'] = retvar(node.default['cl_mysql']['tunable']['max_connections'], mi.max_connections)

   mi = nil
end

instances = get_instances_from_databag('cl_mysql')

instances.each do |instance, value|
   case value
      when Hash
	 group "#{value['group']}" do
	    action :create
	 end

	 user "#{value['user']}" do
	    gid "#{value['group']}"
	    home "#{value['ldir']}"
	    shell "/bin/bash"
	    system true
	    action :create
	 end
   end
end

if (platform?("ubuntu"))
   template "/etc/apparmor.d/usr.sbin.mysqld" do
      source "mysql.apparmor.erb"
      owner  "root"
      group  "root"
      mode   "0644"
      @vg_instances = []
      instances.each do |instance, value|
	 @vg_instances.push "#{instance}"   
      end
      variables (:inst => @vg_instances)      
   end

   instances.each do |instance, value|
      template "/etc/apparmor.d/local/usr.sbin.mysqld_#{instance}" do
	 variables(:prefix => instance, :data_dir => value['ldir'])
	 source "mysql.apparmor_local.erb"
	 owner  "root"
	 group  "root"
	 mode   "0644"
      end
   end
   
   service "apparmor" do
      action [:restart]
   end
   
   if ( node['cgroup'].to_i == 1 )
      package "cgroup-bin" do
	action :install
      end

      template "/etc/cgconfig.conf" do
	 source "cgconfig.conf.erb"
	 owner "root"
	 group "root"
	 mode "0644"
	 @cgroups = {}
	 instances.each do |entry, value|
	    mi = Chef::Recipe::MySQL_Instance.new(value['cgroup_max_memory'], value['max_memory'])
	    @cgroups[entry] = {"cgroup_name" => value['cgroup_name'], "user" => value['user'], "group" => value['group'],
			        "cpushares" => value['cgroup_cpushares'], "memory" => mi.mem_max_use}
	    mi = nil
	 end      
	 variables( :cgroups => @cgroups )
      end   
      
      template "/etc/cgrules.conf" do
	 source "cgrules.conf.erb"
	 owner "root"
	 group "root"
	 mode "0644"
	 @cgroups = {}
	 instances.each do |entry, value|
	    @cgroups[entry[value['name']]] = value['user']
	 end
	 variables( :cgroups => @cgroups )
      end  
      
      service "cgred" do
	 if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
	    provider Chef::Provider::Service::Upstart
	 end	 
	 action :stop
      end	 
      
      service "cgconfig" do
	 if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
	    provider Chef::Provider::Service::Upstart
	 end	 
	 action :stop
      end
      
      execute "force umount cgroups" do
	 command "umount -f -l /sys/fs/cgroup/ 2>/dev/null; echo $?"	    
      end

      execute "sleep 5" do
	 command "sleep 5"
      end

      service "cgconfig" do
	 if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
	    provider Chef::Provider::Service::Upstart
	 end
	 action :start
      end

      service "cgred" do
	 if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
	    provider Chef::Provider::Service::Upstart
	 end
	 action :start
      end
   end
end

instances.each do |instance, value|
   case value
      when Hash
	 node.load_attribute_by_short_filename('default', 'cl_mysql')

	 set_vars(value)

	 $prefix	="#{node['cl_mysql']['prefix']}"
	 $user		="#{node['cl_mysql']['user']}"
	 $group		="#{node['cl_mysql']['group']}"
	 $path		="#{node['cl_mysql']['data_dir']}"
	 $confdir	="#{node['cl_mysql']['conf_dir']}"
	 $pidfile	="#{node['cl_mysql']['pid_file']}"
	 $socket	="#{node['cl_mysql']['socket']}"

	 unless File.exists?($path) && File.directory?($path) 	 
	    template "#{$confdir}/#{$prefix}.cnf" do
	       variables(  :user => node['cl_mysql']['user'],
			   :group => node['cl_mysql']['group'],
			   :datadir => node['cl_mysql']['data_dir'],
			   :conf_dir => node['cl_mysql']['conf_dir'],
			   :pid_file => node['cl_mysql']['pid_file'],
			   :socket => node['cl_mysql']['socket'],
			   :bind_address => node['cl_mysql']['bind_address'],
			   :port => node['cl_mysql']['port'],

			   :character_set_server => node['cl_mysql']['character_set_server'],
			   :default_storage_engine => node['cl_mysql']['default_storage_engine'],
			   :symbolic_links => node['cl_mysql']['symbolic_links'],
		   
			   :slow_query_log_file => node['cl_mysql']['tunable']['slow_query_log_file'],
			   :mysqld_safe_log_error => node['cl_mysql']['mysqld_safe']['log-error'],
			   
			   :key_buffer_size => node['cl_mysql']['tunable']['key_buffer_size'],
			   
			   # Per connection:
			   :sort_buffer_size => node['cl_mysql']['tunable']['sort_buffer_size'],
			   :join_buffer_size => node['cl_mysql']['tunable']['join_buffer_size'],
			   :read_buffer_size => node['cl_mysql']['tunable']['read_buffer_size'],
			   :read_rnd_buffer_size => node['cl_mysql']['tunable']['read_rnd_buffer_size'],
			   :query_cache_limit => node['cl_mysql']['tunable']['query_cache_limit'],
			   :query_cache_size => node['cl_mysql']['tunable']['query_cache_size'],
			   
			   :table_open_cache => node['cl_mysql']['tunable']['table_open_cache'],
			   :table_definition_cache => node['cl_mysql']['tunable']['table_definition_cache'],
			   :thread_stack => node['cl_mysql']['tunable']['thread_stack'],
			   :thread_cache_size => node['cl_mysql']['tunable']['thread_cache_size'],
			   :max_allowed_packet => node['cl_mysql']['tunable']['max_allowed_packet'],
			   :max_heap_table_size => node['cl_mysql']['tunable']['max_heap_table_size'],
			   :tmp_table_size => node['cl_mysql']['tunable']['tmp_table_size'],
			   :myisam_sort_buffer_size => node['cl_mysql']['tunable']['myisam_sort_buffer_size'],
			   
			   :innodb_log_file_size => node['cl_mysql']['tunable']['innodb_log_file_size'],
			   :innodb_log_buffer_size => node['cl_mysql']['tunable']['innodb_log_buffer_size'],
			   :innodb_buffer_pool_size => node['cl_mysql']['tunable']['innodb_buffer_pool_size'],
			   :innodb_additional_mem_pool_size => node['cl_mysql']['tunable']['innodb_additional_mem_pool_size'],
			   :innodb_thread_concurrency => node['cl_mysql']['tunable']['innodb_thread_concurrency'],

			   :innodb_flush_log_at_trx_commit => node['cl_mysql']['tunable']['innodb_flush_log_at_trx_commit'],
			   :innodb_lock_wait_timeout => node['cl_mysql']['tunable']['innodb_lock_wait_timeout'],
			   :innodb_open_files => node['cl_mysql']['tunable']['innodb_open_files'],
			   
			   :max_connections => node['cl_mysql']['tunable']['max_connections'],

			   #:ssl-ca => node['cl_mysql']['tunable']['ssl_ca'],
			   #:ssl-cert => node['cl_mysql']['tunable']['ssl_cert'],
			   #:ssl-key => node['cl_mysql']['tunable']['ssl_key'],

			   :slave_net_timeout => node['cl_mysql']['replica']['slave_net_timeout'],
			   :slave_skip_errors => node['cl_mysql']['replica']['slave_skip_errors'],
			   :log_bin => node['cl_mysql']['replica']['log_bin'],
			   :server_id => node['cl_mysql']['replica']['server_id'],
			   :sync_binlog => node['cl_mysql']['replica']['sync_binlog'],
			   :expire_logs_days => node['cl_mysql']['replica']['expire_logs_days'],
			   :max_binlog_size => node['cl_mysql']['replica']['max_binlog_size'],
			   :relay_log_space_limit => node['cl_mysql']['replica']['relay_log_space_limit'],
			   :auto_increment_increment => node['cl_mysql']['replica']['auto_increment_increment'],
			   :auto_increment_offset => node['cl_mysql']['replica']['auto_increment_offset'],

			   # Global:
			   :concurrent_insert => node['cl_mysql']['tunable']['concurrent_insert'],
			   :query_cache_type => node['cl_mysql']['tunable']['query_cache_type'],
			   
			   :net_read_timeout => node['cl_mysql']['tunable']['net_read_timeout'],
			   :net_write_timeout => node['cl_mysql']['tunable']['net_write_timeout'],
			   :back_log => node['cl_mysql']['tunable']['back_log'],
			   :wait_timeout => node['cl_mysql']['tunable']['wait_timeout'],
			   :slow_query_log_file	=> node['cl_mysql']['tunable']['slow_query_log_file'],
			   
			   
			   :mysqldump_max_allowed_packet => node['cl_mysql']['mysqldump']['max_allowed_packet'],
			   
			   :myisamchk_key_buffer_size => node['cl_mysql']['myisamchk']['key_buffer_size'],
			   :myisamchk_sort_buffer_size => node['cl_mysql']['myisamchk']['sort_buffer_size'],
			   :myisamchk_read_buffer => node['cl_mysql']['myisamchk']['read_buffer'],
			   :myisamchk_write_buffer => node['cl_mysql']['myisamchk']['write_buffer']
	   
			)
	       source "mysql.cnf.erb"
	       owner  "root"
	       group  "root"
	       mode   0644
	       action :create	 
	    end
	 
	    if platform?(%w{debian ubuntu})
	       service "mysql" do
		  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
			provider Chef::Provider::Service::Upstart
		  end
		  action [:stop, :disable]
	       end
	       
	       directory "#{$path}" do
		  owner "root"
		  group "root"
		  mode  0755
		  recursive true
		  action :create
	       end		
	       
	       execute "change owner #{$path}" do
		  command "chown -R #{$user}:#{$group} \"#{$path}\""
	       end		    
	       
	       execute "install new mysql base data" do
		  command "mysql_install_db --no-defaults --user=#{$user} --ldata=#{$path}"
	       end		
	       
	       execute "change owner #{$path}" do
		  command "chown -R #{$user}:#{$group} \"#{$path}\""
	       end		
	       
	       directory "/usr/local/sbin/" do
		  owner "root"
		  group "root"
		  mode 0755
		  action :create
	       end      
	       
	       cookbook_file "/usr/local/sbin/run_mysqld" do
		  source "run_mysqld"
		  owner "root"
		  group "root"
		  mode 0755
		  action :create
	       end
	       
	       execute "run mysqld #{$path}" do
		  command "/usr/local/sbin/run_mysqld \"#{$confdir}/#{$prefix}.cnf\" \"#{$pidfile}\" \"#{$socket}\" \"#{$path}\" \"#{$user}\""	 
	       end
	       
	       cookbook_file "/etc/mysql/grants_#{$prefix}.sql" do
		  source "grants.sql"
		  owner "root"
		  group "root"
		  mode 0755
		  action :create
	       end
	       
	       execute "import mysql privileges" do
		  command "/usr/bin/mysql -S \"#{$socket}\" -u root mysql < \"/etc/mysql/grants_#{$prefix}.sql\""
	       end      

	       execute "stop mysqld" do
		  command "kill -15 `cat #{$pidfile}`"
	       end
	    end
      else
	 Chef::Log.debug("cl_mysql::server - stopped: #{$path} already exist!")
      end
   end
end
