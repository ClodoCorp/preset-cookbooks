include_recipe "apt"

arch = node['kernel']['machine'] =~ /x86_64/ ? 'x86_64' : 'i686'

remote_file "/tmp/install.tgz" do
  source "http://ru.download.ispsystem.com/Linux-cc6/#{arch}/#{node['web_app']['system']['name']}/install.tgz"
  mode 0600
  owner "root"
  group "root"
  backup 0
end

directory "/usr/local/ispmgr" do
  action :create
  owner "root"
  group "root"
  mode 0755
end

execute "run ispmanager install" do
  cwd "/usr/local/ispmgr"
  command "tar -zxf /tmp/install.tgz"
end

template "/usr/local/ispmgr/etc/plugin.source" do
  source "plugin.source.erb"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

remote_file "/usr/local/ispmgr/skins/userdata/mindterm.jar" do
  source "http://ru.download.ispsystem.com/mindterm.jar"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

group "mgradmin" do
  gid 501
end

group "mgrsecure" do
  gid 502
end

group "mgrreseller" do
  gid 503
end

remote_file "/usr/local/ispmgr/etc/ispmgr.lic" do
  source "http://lic.ispsystem.com/ispmgr.lic?ip=#{node['network']['interfaces']['eth0']['addresses'].select { |address, data| data['family'] == 'inet' }[0][0]}"
  owner "root"
  group "root"
  mode "0644"
  backup 0
end

template "/usr/local/ispmgr/etc/ispmgr.conf" do
  source "ispmgr.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  backup 0
  variables ( :ip => node['network']['interfaces']['eth0']['addresses'].select { |address, data| data['family'] == 'inet' }[0][0] )
end

execute "pkgctl -D cache" do
  command "/usr/local/ispmgr/sbin/pkgctl -D cache"
end

execute "apscache" do
  command "/usr/local/ispmgr/sbin/apscache"
end

execute "apache2" do
  command "/usr/local/ispmgr/sbin/pkgctl -D activate apache"
end

#execute "ihttpd" do
#  command "/usr/local/ispmgr/sbin/ihttpd 0.0.0.0 1500 &"
#end

