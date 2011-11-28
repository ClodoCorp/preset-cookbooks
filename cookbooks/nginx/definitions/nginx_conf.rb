
define :nginx_conf do
  template "#{node[:nginx][:dir]}/conf.d/#{params[:name]}.conf" do
    source "confs/#{params[:name]}.conf.erb"
    notifies :reload, resources(:service => "nginx")
    mode 0644
  end
end

