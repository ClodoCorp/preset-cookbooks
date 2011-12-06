
include_recipe "apache2"
include_recipe "apache2::mod_php5"

apache_site "000-default" do
  enable false
end

apache_app "drupal" do
  template "drupal.conf.erb"
  docroot "#{node['web_app']['system']['dir']}"
  server_name "#{node['hostname']}.clodo.ru"
  server_aliases "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}"
end
