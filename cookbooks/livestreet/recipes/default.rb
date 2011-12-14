
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_curl"

package "unzip"

remote_file "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.zip" do
  source "http://sourceforge.net/projects/livestreet/files/LiveStreet%200.5/LiveStreet%200.5.1/LiveStreet_0.5.1.zip/download?use_mirror=autoselect"
  mode "0644"
end

directory "#{node['web_app']['system']['dir']}" do
  owner "www-data"
  group "www-data"
  mode 0755
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd "#{node['web_app']['system']['dir']}"
  command "tar --no-same-owner --strip-components=1 -xzf #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  #unzip #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.zip ; mv -f modx-2.1.5-pl/* .; rm -rf modx-2.1.5-pl
  creates "#{node['web_app']['system']['dir']}/wp-settings.php"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end

execute "chown-webapp" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

