package "nginx"

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
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

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

if node[:nginx][:dirs].is_a?(Hash)
  node[:nginx][:dirs].each do |dir|
    directory "#{dir}" do
      mode 0755
      owner node[:nginx][:user]
      recursive true
      action :create
    end
  end
end

if node[:nginx][:sites].is_a?(Hash)
  node[:nginx][:sites].each do |site|
    nginx_site "#{site}" do
      action "create"
      enable true
    end
  end
end

nginx_site "default" do
  disable true
end

if node[:nginx][:confs].is_a?(Hash)
  node[:nginx][:confs].each do |conf|
    nginx_conf "#{conf}"
  end
end

