include_recipe "php"

fpm_site "#{node['web_app']['system']['name']}" do
  pool "#{node['web_app']['system']['name']}"
  pm_type "dynamic"
  max_children "10"
  min_spare_servers "1"
  max_spare_servers "2"
  enable "true"
end

nginx_site "#{node[:web_app][:system][:name]}.conf" do
  cookbook "wordpress"
  action "create"
  source "wordpress-nginx.conf.erb"
  enable true
  vars (:name => "#{node[:web_app][:system][:name]}", :docroot => "#{node['web_app']['system']['dir']}", :server_name => "#{node['web_app']['ui']['domain']}", :server_aliases => "#{node['hostname']}.clodo.ru")
end

