
include_recipe "apache2"
include_recipe "apache2::mod_php5"

apache_site "default" do
  action :disable
end

apache_site node['web_app']['ui']['domain'] do
  source "#{node['web_app']['system']['name']}.conf.erb"
  variables (:docroot => node['web_app']['system']['dir'],
             :server_name => "#{node['hostname']}.clodo.ru",
             :server_aliases => "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}")
  action :create
end

apache_site node['web_app']['ui']['domain'] do
  action :enable
end
