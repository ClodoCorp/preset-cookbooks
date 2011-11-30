
include_recipe "drupal"
server_fqdn = node[:server_name]

execute "setup drupal" do
  command "php /tmp/drupal.php #{node['web_app']['login']} #{node['web_app']['password']} #{node['web_app']['email']} #{node['web_app']['domain']}"
  action :nothing
end

#cookbook_file "wordpress.php" do
#  path "/tmp/wordpress.php"
#  mode "0600"
#  backup 0
#  notifies :write, resources(:execute => "setup wordpress")
#end

remote_file "/tmp/drupal.php" do
  source "drupal.php"
  cookbook "drupal"
  mode "0600"
  backup 0
  notifies :run, resources(:execute => "setup drupal"), :immediately
end
