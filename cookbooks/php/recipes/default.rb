
pkgs = value_for_platform(
  [ "centos", "redhat", "fedora" ] => {
    "default" => %w{ php53 php53-cli php-pear }
  },
  [ "debian", "ubuntu" ] => {
    "default" => %w{ php5-cgi php5 php5-cli php-pear }
  },
  "default" => %w{ php5-cgi php5 php5-cli php-pear }
)

pkgs.each do |pkg|
  package pkg do
    action :install
  end
end

template "#{node['php']['conf_dir']}/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables (:memory_limit => node[:php][:memory_limit])
  notifies :reload, resources(:service => "apache2"), :immediately
end

service "php-fpm" do
  pattern "php-fpm"
  start_command "/usr/sbin/invoke-rc.d php5-fpm start && sleep 1"
  stop_command "/usr/sbin/invoke-rc.d php5-fpm stop && sleep 1"
  restart_command "/usr/sbin/invoke-rc.d php5-fpm restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d php5-fpm reload && sleep 1"
  supports value_for_platform(
    "default" => { "default" => [:restart, :reload ] }
  )
  action :nothing
end

service "php5-fpm" do
  pattern "php-fpm"
  start_command "/usr/sbin/invoke-rc.d php5-fpm start && sleep 1"
  stop_command "/usr/sbin/invoke-rc.d php5-fpm stop && sleep 1"
  restart_command "/usr/sbin/invoke-rc.d php5-fpm restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d php5-fpm reload && sleep 1"
  supports value_for_platform(
    "default" => { "default" => [:restart, :reload ] }
  )
  action :nothing
end

