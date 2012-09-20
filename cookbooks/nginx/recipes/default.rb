package "nginx"

directory node['nginx']['log_dir'] do
  mode 0755
  owner node['nginx']['user']
  action :create
end

%w{nxensite nxdissite}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

template "#{node['nginx']['dir']}/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

service "nginx" do
  action :start
end

