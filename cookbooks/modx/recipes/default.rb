
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


include_recipe "php::module_curl"
package "exim4-daemon-light"
package "unzip"

remote_file "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.zip" do
  source "modx-2.2.0-pl2.zip"
  mode "0644"
end

directory "#{node['web_app']['system']['dir']}" do
  owner "www-data"
  group "www-data"
  mode 0755
  action :create
  recursive true
end

execute "unzip-modx" do
  cwd "#{node['web_app']['system']['dir']}"
  command "unzip #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.zip ; mv -f modx-2.2.0-pl2/* .; rm -rf modx-2.2.0-pl2"
  creates "#{node['web_app']['system']['dir']}/index.php"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end

execute "chown-modx" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

