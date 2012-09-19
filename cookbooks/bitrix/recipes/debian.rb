include_recipe "apt"

node['apache']['listen'] = [ "127.0.0.1:8080" ]
node['apache']['listen_ssl'] = [ "127.0.0.1:443" ]


case node['web_app']['system']['database']
  when "mysql"
    include_recipe "mysql::server"
end

case node['web_app']['system']['backend']
  when "apache"
    include_recipe "apache"
end

case node['web_app']['system']['frontend']
  when "apache"
    include_recipe "apache"
  when "nginx"
    include_recipe "nginx"
end

apt_repository "zend" do
  uri "http://repos.zend.com/zend-server/deb"
  distribution "server"
  components ["non-free"]
  key "http://repos.zend.com/zend.key"
  action :add
end

%w{zip zem xsl sockets optimizer-plus mysql mcrypt mbstring json gd ftp fileinfo exif curl ctype bz2 bin bcmath}.each do |pkg|
  package "php-5.3-#{pkg}-zend-server"
end

file "/etc/profile.d/zend.sh" do
  action :create
  content "export PATH=$PATH:/usr/local/zend/bin\n"
  mode "0644"
  owner "root"
  group "root"
end

execute "preseed exim4-config" do
  command "debconf-set-selections /var/cache/local/preseeding/exim4-config"
  action :nothing
end

template "/var/cache/local/preseeding/exim4-config" do
  source "exim4-config.seed.erb"
  owner "root"
  group "root"
  mode "0600"
  notifies :run, resources(:execute => "preseed exim4-config"), :immediately
end

package "exim4-daemon-light"

%w{libapache2-mod-rpaf mysql-server nginx-full ntp openssh-server openssh-client}.each do |pkg|
  package pkg
end

directory node['web_app']['system']['dir'] do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
end

template "/etc/apache2/ports.conf" do
  source "ports.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :reload, resources(:service => "apache2"), :immediately
end

apache_site "default" do
  action :disable
end


apache_site node['web_app']['ui']['domain'] do
  source "#{node['web_app']['system']['name']}-apache.conf.erb"
  variables (:docroot => node['web_app']['system']['dir'],
             :server_name => "#{node['hostname']}.clodo.ru",
             :server_aliases => "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}")
  action :create
end

apache_site node['web_app']['ui']['domain'] do
  action :enable
end

%w{autoindex cgi deflate env negotiation reqtimeout setenvif}.each do |mod|
  apache_module mod do
    enable false
  end
end

execute "disable check license" do
  command "sed -i 's|zend_extension_manager.recheck_license_interval=5|zend_extension_manager.recheck_license_interval=0|g' /usr/local/zend/etc/ext.d/extension_manager.ini"
end

execute "config" do
  command "echo 'mbstring.func_overload=2' >> /usr/local/zend/etc/ext.d/mbstring.ini; echo 'mbstring.internal_encoding=UTF-8' >> /usr/local/zend/etc/ext.d/mbstring.ini; sed -i 's|zend_optimizerplus.revalidate_path=0|zend_optimizerplus.revalidate_path=1|g' /usr/local/zend/etc/ext.d/optimizerplus.ini; sed -i 's|zend_optimizerplus.dups_fix=0|zend_optimizerplus.dups_fix=1|g' /usr/local/zend/etc/ext.d/optimizerplus.ini ; sed -i 's|zend_optimizerplus.memory_consumption=(.*)|zend_optimizerplus.memory_consumption=32|g' /usr/local/zend/etc/ext.d/optimizerplus.ini ; sed -i 's|zend_optimizerplus.max_accelerated_files=(.*)|zend_optimizerplus.max_accelerated_files=60000|g' /usr/local/zend/etc/ext.d/optimizerplus.ini"
end

cookbook_file "/usr/local/zend/etc/ext.d/bitrix.ini" do
  owner "root"
  group "root"
  source "bitrix.ini"
end

link "/usr/local/zend/etc/conf.d/bitrix.ini" do
  to "/usr/local/zend/etc/ext.d/bitrix.ini"
end

template "/etc/apache2/conf.d/preset.conf" do
  source "apache2.conf.erb"
  mode "0644"
  owner "root"
  group "root"
  notifies :reload, resources(:service => "apache2"), :immediately
end

nginx_site node['web_app']['ui']['domain'] do
  source "#{node['web_app']['system']['name']}-nginx.conf.erb"
  variables (:docroot => node['web_app']['system']['dir'],
             :server_name => "#{node['hostname']}.clodo.ru",
             :server_aliases => "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}")
  action :create
end

nginx_site node['web_app']['ui']['domain'] do
  action :enable
end

nginx_site "default" do
  action :disable
end

cookbook_file "/etc/mysql/conf.d/99_bitrix.cnf" do
  owner "root"
  group "root"
  source "bitrix.cnf"
end

cookbook_file "/etc/sysctl.d/bitrix.conf" do
  owner "root"
  group "root"
  source "sysctl.conf"
end

execute "sysctl" do
  command "/etc/init.d/procps restart"
end

remote_file "#{node['web_app']['system']['dir']}/bitrixsetup.php" do
  source "http://www.1c-bitrix.ru/download/scripts/bitrixsetup.php"
  mode "0644"
  owner "www-data"
  group "www-data"
end

