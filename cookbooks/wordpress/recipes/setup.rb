
include_recipe "wordpress"


execute "setup wordpress" do
  command "php /tmp/wordpress.php 'login=#{node['web_app']['ui']['login']}' 'pass=#{node['web_app']['ui']['pass']}' 'email=#{node['web_app']['ui']['email']}' 'domain=#{node['hostname']}.clodo.ru' 'title=#{node['web_app']['ui']['title']}' 'db_name=wordpress' 'db_host=localhost' 'db_login=wordpress' 'db_pass=#{node['web_app']['system']['pass']}'"
  action :nothing
end

remote_file "/tmp/wordpress.php" do
  source "wordpress.php"
  cookbook "wordpress"
  mode 0600
  backup 0
  notifies :run, resources(:execute => "setup wordpress"), :immediately
end

file "/tmp/wordpress.php" do
  action :delete
  backup 0
end

