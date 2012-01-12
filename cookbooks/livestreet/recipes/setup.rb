include_recipe "livestreet"
include_recipe "hosts"

hosts "127.0.0.1" do
  action "add"
  host "#{node['web_app']['ui']['domain']}"
end

execute "setup" do
  command "php /tmp/setup.php 'login=#{node['web_app']['ui']['login']}' 'pass=#{node['web_app']['ui']['pass']}' 'email=#{node['web_app']['ui']['email']}' 'domain=#{node['web_app']['ui']['domain']}' 'title=#{node['web_app']['ui']['title']}' 'db_name=#{node['web_app']['system']['name']}' 'db_host=localhost' 'db_login=#{node['web_app']['system']['name']}' 'db_pass=#{node['web_app']['system']['pass']}'"
  action :nothing
end

execute "patch" do
  cwd "#{node['web_app']['system']['dir']}"
  command "patch -p1 < /tmp/c5b8e20d0ec380c2f2222fa266261d22dc36f926.patch"
  action :nothing
end

remote_file "/tmp/c5b8e20d0ec380c2f2222fa266261d22dc36f926.patch" do
  source "c5b8e20d0ec380c2f2222fa266261d22dc36f926.patch"
  cookbook "#{node['web_app']['system']['name']}"
  mode 0600
  backup 0
  notifies :run, resources(:execute => "patch"), :immediately
end


remote_file "/tmp/setup.php" do
  source "setup.php"
  cookbook "#{node['web_app']['system']['name']}"
  mode 0600
  backup 0
  notifies :run, resources(:execute => "setup"), :immediately
end

file "/tmp/setup.php" do
  action :delete
  backup 0
end

file "/tmp/c5b8e20d0ec380c2f2222fa266261d22dc36f926.patch" do
  action :delete
  backup 0
end


directory "#{node['web_app']['system']['dir']}/install" do
  action :delete
  recursive true
end
