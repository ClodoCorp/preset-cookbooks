include_recipe "apt"

node.default['apache']['keepalive'] = "Off"
node.default['apache']['keepaliverequests'] = 0
node.default['apache']['keepalivetimeout'] = 0
node.default['apache']['listen'] = [ "127.0.0.1:8080" ]
node.default['apache']['listen_ssl'] = [ "127.0.0.1:443" ]
node.default['apache']['start_servers'] = 2
node.default['apache']['min_spare_servers'] = 4
node.default['apache']['max_spare_servers'] = 8
node.default['apache']['server_limit'] = 100
node.default['apache']['max_clients'] = 34
node.default['apache']['max_requests_per_child'] = 0


include_recipe "apache"

case node['web_app']['system']['database']
  when "mysql"
    include_recipe "mysql::server"

    file "/etc/mysql/conf.d/preset.cnf" do
      action :delete
      backup 0
    end

    %w{ibdata1 ib_logfile0 ib_logfile1}.each do |f|
      file "/var/lib/mysql/#{f}" do
        action :delete
        backup 0
      end
    end

    cookbook_file "/etc/mysql/conf.d/bitrix.cnf" do
      owner "root"
      group "root"
      source "bitrix.cnf"
      notifies :restart, resources(:service => "mysql"), :immediately
    end
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

%w{zip zem xsl sockets optimizer-plus mysql mcrypt mbstring json gd ftp fileinfo exif curl ctype bz2 bin bcmath data-cache}.each do |pkg|
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

%w{cron libapache2-mod-rpaf mysql-server nginx-full ntp openssh-server openssh-client}.each do |pkg|
  package pkg
end

directory node['web_app']['system']['dir'] do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
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

template "/etc/cron.d/bitrixsetup" do
  source "bitrixsetup.cron.erb"
  variables (:docroot => node['web_app']['system']['dir'], :cronfile => "/etc/cron.d/bitrixsetup")
  mode "0644"
  owner "root"
  group "root"
end

execute "nginx fuck" do
  command "/etc/init.d/nginx restart"
end
