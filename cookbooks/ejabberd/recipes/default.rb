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

service "ejabberd" do
  action :start
end

ruby_block "Add ejabberd user" do
  block do
    # TODO: Check return value and use nicer system call    
    ret = 111
    until ret == 0
        mon=`ejabberdctl status 1>/dev/null;`
	ret = $?
	sleep 1
    end
    system("ejabberdctl register #{node[:web_app][:ui][:login]} #{node[:web_app][:ui][:domain]} #{node[:web_app][:ui][:pass]}")
    ret =$?
    if ret == 0 then
      Chef::Log.info("Add ejabberd user #{node[:web_app][:ui][:login]} successfuly.")
    else
      Chef::Log.info("Add ejabberd user #{node[:web_app][:ui][:login]} fail!")
    end
  end
  action :create
end

#execute "add ejabberd admin user" do
#  command "ejabberdctl register #{node[:web_app][:ui][:login]} #{node[:web_app][:ui][:domain]} #{node[:web_app][:ui][:pass]}"
#end

