
class Chef::Recipe::Config_mysql 	# add class
  include Config_mysql 		# mix module config.rb from libraries
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
   $max_memory		= value

   mc = Chef::Recipe::Config_mysql.new($max_memory, $max_memory)
   node['mysql']['mysqld']['key_buffer_size'] = retvar(node['mysql']['mysqld']['key_buffer_size'], mc.key_buffer_size)
   node['mysql']['mysqld']['sort_buffer_size'] = retvar(node['mysql']['mysqld']['sort_buffer_size'], mc.sort_buffer_size)
   node['mysql']['mysqld']['join_buffer_size'] = retvar(node['mysql']['mysqld']['join_buffer_size'], mc.join_buffer_size)	    
   node['mysql']['mysqld']['read_buffer_size'] = retvar(node['mysql']['mysqld']['read_buffer_size'], mc.read_buffer_size)	    
   node['mysql']['mysqld']['read_rnd_buffer_size'] = retvar(node['mysql']['mysqld']['read_rnd_buffer_size'], mc.read_rnd_buffer_size)
   node['mysql']['mysqld']['query_cache_limit'] = retvar(node['mysql']['mysqld']['query_cache_limit'], mc.query_cache_limit)
   node['mysql']['mysqld']['query_cache_size'] = retvar(node['mysql']['mysqld']['query_cache_size'], mc.query_cache_size)
   node['mysql']['mysqld']['table_open_cache'] = retvar(node['mysql']['mysqld']['table_open_cache'], mc.table_open_cache)
   node['mysql']['mysqld']['table_definition_cache'] = retvar(node['mysql']['mysqld']['table_definition_cache'], mc.table_definition_cache)
   node['mysql']['mysqld']['thread_stack'] = retvar(node['mysql']['mysqld']['thread_stack'], mc.thread_stack)
   node['mysql']['mysqld']['thread_cache_size'] = retvar(node['mysql']['mysqld']['thread_cache_size'], mc.thread_cache_size)
   node['mysql']['mysqld']['max_allowed_packet'] = retvar(node['mysql']['mysqld']['max_allowed_packet'], mc.max_allowed_packet)
   node['mysql']['mysqld']['max_heap_table_size'] = retvar(node['mysql']['mysqld']['max_heap_table_size'], mc.max_heap_table_size)
   node['mysql']['mysqld']['tmp_table_size'] = retvar(node['mysql']['mysqld']['tmp_table_size'], mc.tmp_table_size)
   node['mysql']['mysqld']['myisam_sort_buffer_size'] = retvar(node['mysql']['mysqld']['myisam_sort_buffer_size'], mc.myisam_sort_buffer_size)
   node['mysql']['mysqld']['innodb_log_file_size'] = retvar(node['mysql']['mysqld']['innodb_log_file_size'], mc.innodb_log_file_size)
   node['mysql']['mysqld']['innodb_log_buffer_size'] = retvar(node['mysql']['mysqld']['innodb_log_buffer_size'], mc.innodb_log_buffer_size)
   node['mysql']['mysqld']['innodb_buffer_pool_size'] = retvar(node['mysql']['mysqld']['innodb_buffer_pool_size'], mc.innodb_buffer_pool_size)
   node['mysql']['mysqld']['innodb_additional_mem_pool_size'] = retvar(node['mysql']['mysqld']['innodb_additional_mem_pool_size'], mc.innodb_additional_mem_pool_size)
   node['mysql']['mysqld']['innodb_thread_concurrency'] = retvar(node['mysql']['mysqld']['innodb_thread_concurrency'], mc.innodb_thread_concurrency)
   node['mysql']['mysqld']['max_connections'] = retvar(node['mysql']['mysqld']['max_connections'], mc.max_connections)
   mc = nil
end

set_vars(50)

include_recipe "mysql::client"

# generate all passwords
node['mysql']['server_debian_password'] = node['web_app']['system']['pass']
node['mysql']['server_root_password']   = node['web_app']['system']['pass']
node['mysql']['server_repl_password']   = node['web_app']['system']['pass']

if platform?(%w{debian ubuntu})

  execute "preseed mysql-server" do
    command "debconf-set-selections /tmp/mysql-server.seed"
    action :nothing
  end

  template "/tmp/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end

#  %w{mysql-server.seed}.each do |f|
#    file "/tmp/#{f}" do
#      action :delete
#      backup 0
#    end
#  end


  template "#{node['mysql']['mysqld']['conf_dir']}/debian.cnf" do
    source "debian.cnf.erb"
    owner "root"
    group "root"
    mode "0600"
  end

end

skip_federated = case node['platform']
                 when 'fedora', 'ubuntu'
                   true
                 when 'centos', 'redhat'
                   node['platform_version'].to_f < 6.0
                 else
                   false
                 end


directory "#{node['mysql']['mysqld']['confd_dir']}" do
  owner "root"
  group "root"
  mode 0755
  recursive true
  action :create
end     

template "#{node['mysql']['mysqld']['confd_dir']}/preset.cnf" do
  source "my.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables ( :skip_federated => skip_federated,
                           :confd_dir => node['mysql']['mysqld']['confd_dir'],
                           :bind_address => node['mysql']['mysqld']['bind_address'],
                           :character_set_server => node['mysql']['mysqld']['character_set_server'],
                           :default_storage_engine => node['mysql']['mysqld']['default_storage_engine'],
                           :symbolic_links => node['mysql']['mysqld']['symbolic_links'],
                           :slow_query_log_file => node['mysql']['mysqld']['log_slow_queries'],
                           :key_buffer_size => node['mysql']['mysqld']['key_buffer_size'],
                           :sort_buffer_size => node['mysql']['mysqld']['sort_buffer_size'],
                           :join_buffer_size => node['mysql']['mysqld']['join_buffer_size'],
                           :read_buffer_size => node['mysql']['mysqld']['read_buffer_size'],
                           :read_rnd_buffer_size => node['mysql']['mysqld']['read_rnd_buffer_size'],
                           :query_cache_limit => node['mysql']['mysqld']['query_cache_limit'],
                           :query_cache_size => node['mysql']['mysqld']['query_cache_size'],
                           :table_open_cache => node['mysql']['mysqld']['table_open_cache'],
                           :table_definition_cache => node['mysql']['mysqld']['table_definition_cache'],
                           :thread_stack => node['mysql']['mysqld']['thread_stack'],
                           :thread_cache_size => node['mysql']['mysqld']['thread_cache_size'],
                           :max_allowed_packet => node['mysql']['mysqld']['max_allowed_packet'],
                           :max_heap_table_size => node['mysql']['mysqld']['max_heap_table_size'],
                           :tmp_table_size => node['mysql']['mysqld']['tmp_table_size'],
                           :myisam_sort_buffer_size => node['mysql']['mysqld']['myisam_sort_buffer_size'],
                           :innodb_log_file_size => node['mysql']['mysqld']['innodb_log_file_size'],
                           :innodb_log_buffer_size => node['mysql']['mysqld']['innodb_log_buffer_size'],
                           :innodb_buffer_pool_size => node['mysql']['mysqld']['innodb_buffer_pool_size'],
                           :innodb_additional_mem_pool_size => node['mysql']['mysqld']['innodb_additional_mem_pool_size'],
                           :innodb_thread_concurrency => node['mysql']['mysqld']['innodb_thread_concurrency'],
                           :innodb_flush_log_at_trx_commit => node['mysql']['mysqld']['innodb_flush_log_at_trx_commit'],
                           :innodb_lock_wait_timeout => node['mysql']['mysqld']['innodb_lock_wait_timeout'],
                           :innodb_open_files => node['mysql']['mysqld']['innodb_open_files'],
                           :max_connections => node['mysql']['mysqld']['max_connections'],
                           :concurrent_insert => node['mysql']['mysqld']['concurrent_insert'],
                           :query_cache_type => node['mysql']['mysqld']['query_cache_type'],
                           :net_read_timeout => node['mysql']['mysqld']['net_read_timeout'],
                           :net_write_timeout => node['mysql']['mysqld']['net_write_timeout'],
                           :back_log => node['mysql']['mysqld']['back_log'],
                           :wait_timeout => node['mysql']['mysqld']['wait_timeout'],
                           :mysqldump_max_allowed_packet => node['mysql']['mysqldump']['max_allowed_packet'],
                           :myisamchk_key_buffer_size => node['mysql']['myisamchk']['key_buffer_size'],
                           :myisamchk_sort_buffer_size => node['mysql']['myisamchk']['sort_buffer_size'],
                           :myisamchk_read_buffer => node['mysql']['myisamchk']['read_buffer'],
                           :myisamchk_write_buffer => node['mysql']['myisamchk']['write_buffer'])
end

package "mysql-server" do
  action :install
end

service "mysql" do
  service_name value_for_platform([ "centos", "redhat", "suse", "fedora" ] => {"default" => "mysqld"}, "default" => "mysql")
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    provider Chef::Provider::Service::Upstart
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => true, :restart => true, :reload => true
  action :start
end


unless platform?(%w{debian ubuntu})

  execute "assign-root-password" do
    command "/usr/bin/mysqladmin -u root password \"#{node['mysql']['server_root_password']}\""
    action :run
    only_if "/usr/bin/mysql -u root -e 'show databases;'"
  end

end

grants_path = "#{node['mysql']['mysqld']['conf_dir']}/mysql_grants.sql"

begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    action :create
  end
end

execute "mysql-install-privileges" do
  command "/usr/bin/mysql -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']} < #{grants_path}"
  action :nothing
  subscribes :run, resources("template[#{grants_path}]"), :immediately
end

file "#{node['mysql']['mysqld']['conf_dir']}/#{grants_path}" do
  action :delete
  backup 0
end

