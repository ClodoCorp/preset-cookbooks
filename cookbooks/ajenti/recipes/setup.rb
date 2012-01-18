
require 'base64'
require 'digest/sha1'
node['web_app']['ui']['passhash'] = Base64.encode64(Digest::SHA1.digest("#{node['web_app']['ui']['pass']}"))


%w{python-psutil python-imaging}.each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

%w{services webserver_common power hosts network dns taskmgr terminal users iptables shell fm filesystems notepad cron logs sysload pkgman}.each do |pkg|
  execute "get #{pkg}" do
    command "/usr/bin/ajenti-pkg get #{pkg}"
  end
end


execute "remove admin user" do
  command "sed '/^\[users\]/,+2 d' -i /etc/ajenti/ajenti.conf"
end

template "/etc/ajenti/ajenti.conf" do
  source "ajenti.conf"
  mode 0600
  backup 0
  variables (:login => node[:web_app][:ui][:login], :password => node['web_app']['ui']['passhash'])
end

service "ajenti" do
  action :restart
end

