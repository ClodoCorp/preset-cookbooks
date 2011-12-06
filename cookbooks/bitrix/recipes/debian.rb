include_recipe "apt"

apt_repository "zwas" do
  uri "http://repos-source.zend.com/zend-server/deb"
  distribution "server"
  components ["non-free"]
  key "http://repos.zend.com/zend.key"
  action :add
end


%w{ geoip-bin geoip-database libgeoip-dev autoconf bash bc catdoc csync2 expect gcc gzip apache2 libidn11 libidn11-dev librsync-dev }.each do |pkg|
  package "#{pkg}"
end

%w{ libtasn1-3 libtasn1-3-dev libtasn1-3-bin make memcached libapache2-mod-geoip libapache2-mod-rpaf }.each do |pkg|
  package "#{pkg}"
end

%w{ msmtp mysql-server nginx ntp openssh-server openssh-client php-5.3-memcache-zend-server libpoppler-cil poppler-data poppler-utils }.each do |pkg|
  package "#{pkg}"
end

%w{ rsync libsqlite3-0 sqlite3 libsqlite3-dev stunnel4 tar xinetd zend-server-ce-php-5.3 }.each do |pkg|
  package "#{pkg}"
end

%w{ /etc/nginx/bx/conf /etc/nginx/bx/site_ext_enabled /etc/nginx/bx/site_enabled /etc/nginx/bx/site_avaliable /etc/bx_cluster/nodes }.each do |dir|
  directory "#{dir}" do
    action :create
    owner "root"
    group "root"
    mode 0755
    recursive true
  end
end


