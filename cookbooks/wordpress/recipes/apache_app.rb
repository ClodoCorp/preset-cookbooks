
include_recipe "apache"
include_recipe "apache::mod_php5"

apache_site "000-default" do
  enable false
end

apache_app "wordpress" do
  template "wordpress.conf.erb"
  docroot "#{node['wordpress']['dir']}"
  server_name "#{node[:server_name]}"
  server_aliases "www.#{node[:server_name]} #{node['wordpress']['server_aliases']}"
end
