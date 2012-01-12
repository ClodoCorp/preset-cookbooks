include_recipe "nginx"

package "nginx" do
  action :purge
  options "--force-yes"
end

package "nginx-extras"

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

%{/var/www/ /var/www/cache /var/www/temp}.each do |dir|
  directory "#{dir}" do
    mode 0755
    owner node[:nginx][:user]
    recursive true
    action :create
  end
end

nginx_conf "mirror"

nginx_site "mirror.clodo.ru" do
  action "create"
  enable true
end

nginx_site "default" do
  action "delete"
  disable true
end

