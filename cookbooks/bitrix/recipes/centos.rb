
remote_file "/tmp/bitrix-env.sh" do
  source "http://mirror.clodo.ru/repos.1c-bitrix.ru/yum/bitrix-env.sh"
  owner "root"
  group "root"
  mode 0700
  backup 0
end

#execute "use mirror" do
#  command "sed -i '/baseurl/ s/http:\/\//http:\/\/mirror.clodo.ru\//' /tmp/bitrix-env.sh"
#end

execute "bitrix" do
  command "/tmp/bitrix-env.sh"
end

execute "firewall" do
  command "/usr/bin/system-config-securitylevel-tui -q --enabled --port=80:tcp --port=443:tcp --port=10082:tcp --port=5222:tcp --port=5223:tcp --port=25:tcp"
end

execute "performance" do
  command "sed 's|zend_datacache.enable=0|zend_datacache.enable=1|g' -i /usr/local/zend/etc/conf.d/datacache.ini"
end

execute "memcached on" do
  command "chkconfig memcached on"
end

execute "memcached param" do
  command "sed 's|OPTIONS=\"\"|OPTIONS=\"-a 0777 -s /var/run/memcached/memcached.sock\"|g' -i /etc/sysconfig/memcached"
end

execute "memcached start" do
  command "/etc/init.d/memcached start"
end

execute "zend-server restart" do
  command "/etc/init.d/zend-server restart"
end

