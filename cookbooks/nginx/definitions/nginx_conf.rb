
define :nginx_conf do
  template "#{node[:nginx][:dir]}/conf.d/#{params[:name]}.conf" do
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    backup 0
    owner "root"
    group "root"
    mode 0644
    source "confs/#{params[:name]}.conf.erb"
    notifies :reload, resources(:service => "nginx")
  end
end

