include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "php::module_curl"

package "exim4-daemon-light"

server_fqdn = node[:server_name]

node.set['joomla']['www']['password'] = "test"

node.set['joomla']['db']['password'] = "test"

remote_file "#{Chef::Config[:file_cache_path]}/joomla-#{node['joomla']['version']}.tar.gz" do
  checksum node['joomla']['checksum']
#  source "http://joomlacode.org/gf/download/frsrelease/16024/69673/Joomla_#{node['joomla']['version']}-Stable-Full_Package.tar.gz"
  source "http://joomlaportal.ru/downloads/joomla/Joomla_#{node['joomla']['version']}-Stable-Full_Package_Russian_v1.tar.gz"
  mode "0644"
end

directory "#{node['joomla']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-joomla" do
  cwd node['joomla']['dir']
  command "tar -xzf #{Chef::Config[:file_cache_path]}/joomla-#{node['joomla']['version']}.tar.gz"
  creates "#{node['joomla']['dir']}/index.php"
end

execute "owner-joomla" do
  cwd node['joomla']['dir']
  command "chown -R www-data:www-data #{node['joomla']['dir']}"
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
  backup 0
  variables(
    :user     => node['joomla']['db']['user'],
    :password => node['joomla']['db']['password'],
    :database => node['joomla']['db']['database']
  )
  notifies :run, resources(:execute => "mysql-install-wp-privileges"), :immediately
end

file "/tmp/wp-grants.sql" do
  action :delete
  backup 0
end

execute "create #{node['joomla']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p#{node['mysql']['server_root_password']} create #{node['joomla']['db']['database']}"
end

file "#{node['joomla']['dir']}/.htaccess" do
  content "#{node['joomla']['dir']}/htaccess.txt"
  provider Chef::Provider::File::Copy
end

#execute "http://#{server_fqdn}/wp-admin/install.php" do
#  command "echo http://#{server_fqdn}/wp-admin/install.php"
#  action :nothing
#end


#template "#{node['wordpress']['dir']}/wp-config.php" do
#  source "wp-config.php.erb"
#  owner "root"
#  group "root"
#  mode "0644"
#  variables(
#    :database        => node['wordpress']['db']['database'],
#    :user            => node['wordpress']['db']['user'],
#    :password        => node['wordpress']['db']['password'],
#    :auth_key        => node['wordpress']['keys']['auth'],
#    :secure_auth_key => node['wordpress']['keys']['secure_auth'],
#    :logged_in_key   => node['wordpress']['keys']['logged_in'],
#    :nonce_key       => node['wordpress']['keys']['nonce']
#  )
#  notifies :runwrite, "execute[http://#{server_fqdn}/wp-admin/install.php]"
#  notifies :run, resources(:execute => "http://#{server_fqdn}/wp-admin/install.php")
#end

