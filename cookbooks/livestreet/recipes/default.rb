include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_curl"

package "exim4-daemon-light"
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

execute "unpack" do
  cwd "#{node['web_app']['system']['dir']}"
  command "unzip #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.zip"
  creates "#{node['web_app']['system']['dir']}/index.php"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end

execute "owner" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

