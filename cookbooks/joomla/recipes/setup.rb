
include_recipe "joomla"
server_fqdn = node[:server_name]

execute "setup joomla" do
  command "php /tmp/joomla.php #{node['web_app']['login']} #{node['web_app']['password']} #{node['web_app']['email']} #{node['web_app']['domain']}"
  action :nothing
end

#cookbook_file "wordpress.php" do
#  path "/tmp/wordpress.php"
#  mode "0600"
#  backup 0
#  notifies :write, resources(:execute => "setup wordpress")
#end

remote_file "/tmp/joomla.php" do
  source "joomla.php"
  cookbook "joomla"
  mode "0600"
  backup 0
  notifies :run, resources(:execute => "setup joomla"), :immediately
end


directory "#{node['joomla']['dir']}/installation" do
  recursive true
  action :delete
end
