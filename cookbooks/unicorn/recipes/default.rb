
package "unicorn-http"

%w{ucensite ucdissite}.each do |ucscript|
  template "/usr/sbin/#{ucscript}" do
    source "#{ucscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end


unicorn_app "default" do
  template "default.conf.erb"
  rails_root "/var/www/default"
  rails_env "production"
end


service "unicorn-http" do
  start_command "/usr/sbin/invoke-rc.d unicorn-http start && sleep 1"
  stop_command "/usr/sbin/invoke-rc.d unicorn-http stop && sleep 1"
  restart_command "/usr/sbin/invoke-rc.d unicorn-http restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d unicorn-http reload && sleep 1"
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
    notifies :reload, resources(:service => "unicorn-http"), :immediately
  end
end

service "unicorn-http" do
  action :enable
end

