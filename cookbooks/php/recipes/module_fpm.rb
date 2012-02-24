
include_recipe "php"
include_recipe "apt"


#apt_repository "dotdeb" do
#  uri "http://packages.dotdeb.org"
#  distribution "stable"
#  components ["all"]
#  key "http://www.dotdeb.org/dotdeb.gpg"
#  action :add
#end

package "mysql-server" do
  action :upgrade
end

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

%w{sites-available sites-enabled}.each do |dir|
  directory "/etc/php5/fpm/#{dir}" do
    action :create
    mode 0755
    owner "root"
    group "root"
    notifies :reload, resources(:service => "#{node[:php][:fpm_service]}")
  end
end

fpm_site "default" do
  pool "default"
  pm_type "dynamic"
  max_children "10"
  min_spare_servers "1"
  max_spare_servers "2"
  enable "true"
  cookbook "php"
end

service "#{node[:php][:fpm_service]}" do
  action :enable
end

nginx_site "default" do
  action "create"
  source "default.conf.erb"
  enable true
end


