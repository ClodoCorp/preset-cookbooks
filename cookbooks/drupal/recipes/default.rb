include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "php::module_gd"
include_recipe "php::module_curl"
include_recipe "system"
package "exim4-daemon-light"

system_mirror_file "#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz" do
  path "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
#  name "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  source "#{node['web_app']['system']['downloads']}/files/projects/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  mode 0644
end

directory node['web_app']['system']['dir'] do
  owner "www-data"
  group "www-data"
  mode 0755
  action :create
  recursive true
end

execute "unpack" do
  cwd node['web_app']['system']['dir']
  command "tar --no-same-owner --strip-components 1 -xzvf #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  creates "#{node['web_app']['system']['dir']}/install.php"
end

mysql_db node['web_app']['system']['name'] do
  action "create"
end

mysql_grants node['web_app']['system']['name'] do
end

file "#{node['web_app']['system']['dir']}/sites/default/settings.php" do
  content "#{node['web_app']['system']['dir']}/sites/default/default.settings.php"
  provider Chef::Provider::File::Copy
end

execute "owner" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

