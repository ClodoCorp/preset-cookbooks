
package "unicorn"

%w{ucensite ucdissite}.each do |ucscript|
  template "/usr/sbin/#{ucscript}" do
    source "#{ucscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

service "unicorn" do
  start_command "/usr/sbin/invoke-rc.d unicorn start && sleep 1"
  stop_command "/usr/sbin/invoke-rc.d unicorn stop && sleep 1"
  restart_command "/usr/sbin/invoke-rc.d unicorn restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d unicorn reload && sleep 1"
  supports value_for_platform(
    "default" => { "default" => [:restart, :reload ] }
  )
  action :nothing
end


%w{sites-available sites-enabled}.each do |dir|
  directory "/etc/unicorn/#{dir}" do
    action :create
    mode 0755
    owner "root"
    group "root"
    notifies :reload, resources(:service => "unicorn"), :immediately
  end
end

service "unicorn" do
  action :enable
end

