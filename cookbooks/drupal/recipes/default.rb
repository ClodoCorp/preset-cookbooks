
include_recipe "apache"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "php::module_curl"



server_fqdn = node[:server_name]

node.set['drupal']['www']['password'] = "test"

node.set['drupal']['db']['password'] = "test"
#node.set['drupal']['keys']['auth'] = "test"
#node.set['drupal']['keys']['secure_auth'] = "test"
#node.set['drupal']['keys']['logged_in'] = "test"
#node.set['drupal']['keys']['nonce'] = "test"

remote_file "#{Chef::Config[:file_cache_path]}/drupal-#{node['drupal']['version']}.tar.gz" do
  checksum node['drupal']['checksum']
  source "http://ftp.drupal.org/files/projects/drupal-#{node['drupal']['version']}.tar.gz"
#http://ru.wordpress.org/wordpress-3.2.1-ru_RU.tar.gz
  mode "0644"
end

directory "#{node['drupal']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-drupal" do
  cwd node['drupal']['dir']
  command "tar --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/drupal-#{node['drupal']['version']}.tar.gz"
  creates "#{node['drupal']['dir']}/install.php"
end

execute "owner-drupal" do
  cwd node['drupal']['dir']
  command "chown -R www-data:www-data #{node['drupal']['dir']}"
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
    :user     => node['drupal']['db']['user'],
    :password => node['drupal']['db']['password'],
    :database => node['drupal']['db']['database']
  )
  notifies :run, resources(:execute => "mysql-install-wp-privileges"), :immediately
end

file "/tmp/wp-grants.sql" do
  action :delete
  backup 0
end

execute "create #{node['drupal']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p#{node['mysql']['server_root_password']} create #{node['drupal']['db']['database']}"
end

file "#{node['drupal']['dir']}/sites/default/settings.php" do
  content "#{node['drupal']['dir']}/sites/default/default.settings.php"
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

