
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_curl"

remote_file "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz" do
  source "#{node['web_app']['system']['downloads']}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}-ru_RU.tar.gz"
  mode "0644"
end

directory "#{node['web_app']['system']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd "#{node['web_app']['system']['dir']}"
  command "tar --no-same-owner --strip-components 1 -xzf #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  creates "#{node['web_app']['system']['dir']}/wp-settings.php"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end


template "#{node['wordpress']['dir']}/wp-config.php" do
  source "wp-config.php.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :database        => node['web_app']['system']['name'],
    :user            => node['web_app']['system']['name'],
    :password        => node['web_app']['system']['pass'],
    :auth_key        => node['wordpress']['keys']['auth'],
    :secure_auth_key => node['wordpress']['keys']['secure_auth'],
    :logged_in_key   => node['wordpress']['keys']['logged_in'],
    :nonce_key       => node['wordpress']['keys']['nonce']
  )
end

execute "chown-wordpress" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

