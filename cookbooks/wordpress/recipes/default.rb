
include_recipe "apache"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_curl"

server_fqdn = node[:server_name]

node.set['wordpress']['www']['password'] = "test"

node.set['wordpress']['db']['password'] = "test"
node.set['wordpress']['keys']['auth'] = "test"
node.set['wordpress']['keys']['secure_auth'] = "test"
node.set['wordpress']['keys']['logged_in'] = "test"
node.set['wordpress']['keys']['nonce'] = "test"

remote_file "#{Chef::Config[:file_cache_path]}/wordpress-#{node['wordpress']['version']}.tar.gz" do
  checksum node['wordpress']['checksum']
  source "http://wordpress.org/wordpress-#{node['wordpress']['version']}.tar.gz"
#http://ru.wordpress.org/wordpress-3.2.1-ru_RU.tar.gz
  mode "0644"
end

directory "#{node['wordpress']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd node['wordpress']['dir']
  command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/wordpress-#{node['wordpress']['version']}.tar.gz"
  creates "#{node['wordpress']['dir']}/wp-settings.php"
end

execute "mysql-install-wp-privileges" do
  command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < /tmp/wp-grants.sql"
  action :nothing
end

template "/tmp/wp-grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node['wordpress']['db']['user'],
    :password => node['wordpress']['db']['password'],
    :database => node['wordpress']['db']['database']
  )
  notifies :run, resources(:execute => "mysql-install-wp-privileges"), :immediately
end

file "/tmp/wp-grants.sql" do
  action :delete
  backup 0
end

execute "create #{node['wordpress']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p#{node['mysql']['server_root_password']} create #{node['wordpress']['db']['database']}"
end

#execute "http://#{server_fqdn}/wp-admin/install.php" do
#  command "echo http://#{server_fqdn}/wp-admin/install.php"
#  action :nothing
#end


template "#{node['wordpress']['dir']}/wp-config.php" do
  source "wp-config.php.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :database        => node['wordpress']['db']['database'],
    :user            => node['wordpress']['db']['user'],
    :password        => node['wordpress']['db']['password'],
    :auth_key        => node['wordpress']['keys']['auth'],
    :secure_auth_key => node['wordpress']['keys']['secure_auth'],
    :logged_in_key   => node['wordpress']['keys']['logged_in'],
    :nonce_key       => node['wordpress']['keys']['nonce']
  )
#  notifies :runwrite, "execute[http://#{server_fqdn}/wp-admin/install.php]"
#  notifies :run, resources(:execute => "http://#{server_fqdn}/wp-admin/install.php")
end

