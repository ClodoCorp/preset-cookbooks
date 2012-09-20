include_recipe "php"

fpm_site "#{node['web_app']['system']['name']}" do
  pool "#{node['web_app']['system']['name']}"
  pm_type "dynamic"
  max_children "10"
  min_spare_servers "1"
  max_spare_servers "2"
  enable "true"
end

fpm_php_value "date.timezone" do
  value "Europe/Moscow"
end

nginx_site "#{node[:web_app][:system][:name]}.conf" do
  cookbook "modx"
  action :create
  source "modx-nginx.conf.erb"
  variables (:cache => false, :name => "#{node[:web_app][:system][:name]}", :docroot => "#{node['web_app']['system']['dir']}", :server_name => "#{node['hostname']}.clodo.ru", :server_aliases => "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}")
end

nginx_site "#{node[:web_app][:system][:name]}.conf" do
  action :enable
end
