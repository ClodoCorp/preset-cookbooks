package "ejabberd"

service "ejabberd" do
  action :enable
  supports :restart => true
end

template "/etc/ejabberd/ejabberd.cfg" do
  source "ejabberd.cfg.erb"
  variables(:jabber_domain => node[:web_app][:ui][:domain])
  notifies :restart, resources(:service => "ejabberd")
  owner "root"
  group "ejabberd"
  mode 0640
  action :create
end

execute "add ejabberd admin user" do
  command "ejabberdctl register #{node[:web_app][:ui][:login]} #{node[:web_app][:ui][:domain]} #{node[:web_app][:ui][:pass]}"
end

service "ejabberd" do
  action :start
end
