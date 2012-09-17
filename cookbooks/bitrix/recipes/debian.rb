include_recipe "apt"
include_recipe "mysql::server"
include_recipe "apache2"
include_recipe "nginx"

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

%w{libapache2-mod-rpaf mysql-server nginx-full ntp openssh-server openssh-client exim4-daemon-light}.each do |pkg|
  package pkg
end

template "/var/share/local/preseed/exim4-config" do
  source "exim4-config.seed.erb"
  mode 0644
  owner "root"
  group "root"
end

execute "preseed" do
  command "debconf-set-selections -v /var/share/local/preseed/exim4-config"
end

directory "/var/www/htdocs" do
  owner "www-data"
  group "www-data"
  mode "0755"
  recursive true
end

execute "dpkg-reconfigure" do
  command "dpkg-reconfigure exim4-config"
end

nginx_site node['web_app']['ui']['domain'] do
  source "bitrix.erb"
  action :enable
end

apache_site "000-default" do
  enable false
end

apache_app node['web_app']['ui']['domain'] do
  template "#{node['web_app']['system']['name']}.conf.erb"
  docroot node['web_app']['system']['dir']
  server_name "#{node['hostname']}.clodo.ru"
  server_aliases "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}"
end


%w{autoindex cgi deflate env negotiation reqtimeout setenvif}.each do |mod|
  apache_module mod do
    enable false
  end
end
