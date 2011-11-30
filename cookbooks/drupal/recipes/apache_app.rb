
include_recipe "apache"
include_recipe "apache::mod_php5"

apache_site "000-default" do
  enable false
end

apache_app "drupal" do
  template "drupal.conf.erb"
  docroot "#{node['drupal']['dir']}"
  server_name "#{node[:server_name]}"
  server_aliases "www.#{node[:server_name]} #{node['drupal']['server_aliases']}"
end
