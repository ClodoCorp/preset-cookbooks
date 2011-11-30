
include_recipe "apache"
include_recipe "apache::mod_php5"

apache_site "000-default" do
  enable false
end

apache_app "joomla" do
  template "joomla.conf.erb"
  docroot "#{node['joomla']['dir']}"
  server_name "#{node[:server_name]}"
  server_aliases "www.#{node[:server_name]} #{node['joomla']['server_aliases']}"
end

apache_php_value "output_buffering" do
  value "Off"
end