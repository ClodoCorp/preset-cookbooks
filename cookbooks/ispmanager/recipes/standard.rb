include_recipe "apt"

#apt_repository "ajenti" do
#  uri "http://repo.ajenti.org/debian"
#  distribution "main"
#  components ["main"]
#  key "http://repo.ajenti.org/debian/key"
#  action :add
#end

#package "ajenti"

remote_file "/tmp/install.tgz" do
  source "http://ru.download.ispsystem.com/Linux-cc6/x86_64/ISPmanager-Lite/install.tgz"
  mode 0700
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
#  creates "#{node['drupal']['dir']}/install.php"
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

#user u['id'] do
#  uid u['uid']
#  gid u['gid']
#  shell u['shell']
#  comment u['comment']
#  supports :manage_home => true
#  home home_dir
#  notifies :create, "ruby_block[reset group list]", :immediately
#end

#ruby_block "reset group list" do
#  block do
#    Etc.endgrent
#  end
#  action :nothing
#end

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
%w{apache bzip cron db4 dns fw myadmin mysql ntp php phpext quota tar smtp unzip zip}.each do |pkg|
  execute "pkgctl -D activate #{pkg}" do
    command "/usr/local/ispmgr/sbin/pkgctl -D activate #{pkg}"
  end
end

