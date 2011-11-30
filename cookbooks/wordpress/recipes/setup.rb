
include_recipe "wordpress"
server_fqdn = node[:server_name]

execute "setup wordpress" do
  command "php /tmp/wordpress.php #{node['web_app']['login']} #{node['web_app']['password']} #{node['web_app']['email']} #{node['web_app']['domain']}"
  action :nothing
end

#cookbook_file "wordpress.php" do
#  path "/tmp/wordpress.php"
#  mode "0600"
#  backup 0
#  notifies :write, resources(:execute => "setup wordpress")
#end

remote_file "/tmp/wordpress.php" do
  source "wordpress.php"
  cookbook "wordpress"
  mode "0600"
  backup 0
  notifies :run, resources(:execute => "setup wordpress"), :immediately
end
