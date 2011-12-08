
include_recipe "modx"


execute "setup modx" do
  command "php /tmp/modx.php 'login=#{node['web_app']['ui']['login']}' 'pass=#{node['web_app']['ui']['pass']}' 'email=#{node['web_app']['ui']['email']}' 'domain=#{node['hostname']}.clodo.ru' 'title=#{node['web_app']['ui']['title']}' 'db_name=#{node['web_app']['system']['name']}' 'db_host=localhost' 'db_login=#{node['web_app']['system']['name']}' 'db_pass=#{node['web_app']['system']['pass']}'"
  action :nothing
end

remote_file "/tmp/modx.php" do
  source "modx.php"
  cookbook "modx"
  mode 0600
  backup 0
  notifies :run, resources(:execute => "setup modx"), :immediately
end

file "/tmp/modx.php" do
  action :delete
  backup 0
end

