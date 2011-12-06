
include_recipe "php"

case node['platform']
when "debian", "ubuntu"
  package "php5-fpm" do
    action :install
  end
end


%w{fpmensite fpmdissite}.each do |fpmscript|
  template "/usr/sbin/#{fpmscript}" do
    source "#{fpmscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

execute "modify php-fpm include" do
  command "sed -i 's|include=/etc/php5/fpm/.*|include=/etc/php5/fpm/sites-enabled/*|g' /etc/php5/fpm/php-fpm.conf"
end

fpm_app "default" do
  template "default.conf.erb"
  cookbook "php"
  pool "default"
  pm_type "dynamic"
  max_children "10"
  min_spare_servers "1"
  max_spare_servers "2"
end


%w{sites-available sites-enabled}.each do |dir|
  directory "/etc/php5/fpm/#{dir}" do
    action :create
    mode 0755
    owner "root"
    group "root"
    notifies :reload, resources(:service => "#{node[:php][:fpm_service]}")
  end
end

service "#{node[:php][:fpm_service]}" do
  action :enable
end

