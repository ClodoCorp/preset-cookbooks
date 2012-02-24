
include_recipe "php"
include_recipe "php::module_fpm"

fpm_site "000-default" do
  enable false
end

fpm_app "#{node['web_app']['ui']['name']}" do
  docroot "#{node['web_app']['system']['dir']}"
  pool "pool-#{node['web_app']['ui']['domain']}"
  pm_type "dynamic"
  max_children "10"
  min_spare_servers "3"
  max_spare_servers "5"
  vars => (:server_name => "#{node['hostname']}.clodo.ru", :server_aliases => "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}")
end

fpm_php_value "output_buffering" do
  value "Off"
end

