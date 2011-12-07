
include_recipe "drupal"

execute "setup drupal" do
  command "php /tmp/drupal.php 'login=#{node['web_app']['ui']['login']}' 'pass=#{node['web_app']['ui']['pass']}' 'email=#{node['web_app']['ui']['email']}' 'domain=#{node['hostname']}.clodo.ru' 'title=#{node['web_app']['ui']['title']}' 'db_name=drupal' 'db_host=localhost' 'db_login=drupal' 'db_pass=#{node['web_app']['system']['pass']}'"
  action :nothing
end

remote_file "/tmp/drupal.php" do
  source "drupal.php"
  cookbook "drupal"
  mode 0600
  backup 0
  notifies :run, resources(:execute => "setup drupal"), :immediately
end

file "/tmp/drupal.php" do
  action :delete
  backup 0
end

