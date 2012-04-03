include_recipe "php"

case node[:web_app][:system][:database]
  when "mysql"
    include_recipe "mysql::server"
    include_recipe "php::module_mysql"
end


case node[:web_app][:system][:frontend]
  when "apache"
    include_recipe "apache2"
  when "nginx"
    include_recipe "nginx"
end

case node[:web_app][:system][:backend]
  when "apache"
    include_recipe "apache2"
  when "php"
    include_recipe "php::module_fpm"
end

include_recipe "php::module_gd"
include_recipe "php::module_curl"

package "exim4-daemon-light"

remote_file "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz" do
  source "#{node['web_app']['system']['downloads']}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}-ru_RU.tar.gz"
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
  command "tar --no-same-owner --strip-components=1 -xzf #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  creates "#{node['web_app']['system']['dir']}/wp-settings.php"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end

execute "owner" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

