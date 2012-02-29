include_recipe "rails"

case node[:web_app][:system][:database]
  when "mysql"
    include_recipe "mysql::server"
    include_recipe "mysql::client"
end

include_recipe "nginx"


remote_file "#{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz" do
  source "http://rubyforge.org/frs/download.php/#{node[:redmine][:dl_id]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  mode "0644"
end

directory "#{node['web_app']['system']['dir']}" do
  owner "www-data"
  group "www-data"
  mode "0755"
  action :create
  recursive true
end

execute "unpack" do
  cwd "#{node['web_app']['system']['dir']}"
  command "tar --strip-components=1 -xzf #{Chef::Config[:file_cache_path]}/#{node['web_app']['system']['name']}-#{node['web_app']['system']['version']}.tar.gz"
  creates "#{node['web_app']['system']['dir']}/Rakefile"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end

execute "owner" do
  command "chown -R www-data:www-data #{node['web_app']['system']['dir']}"
end

template "#{node['web_app']['system']['dir']}/config/database.yml" do
  source "database.yml.erb"
  owner "root"
  group "root"
  mode "0664"
end


execute "seed login" do
  command "sed -i 's|User.create :login => \"admin\"|User.create :login => \"#{node[:web_app][:ui][:login]}\"|g' #{node['web_app']['system']['dir']}/db/migrate/001_setup.rb"
end

execute "seed pass" do
  cwd "#{node['web_app']['system']['dir']}"
  command "RAILS_ENV=production script/runner 'user = User.find(:first, :conditions => {:admin => true}) ; user.password, user.password_confirmation = \"password\"; user.save!'"
end

execute "seed email" do
  command "sed -i 's|:mail => \"admin@example.net\"|:mail => \"#{node[:web_app][:ui][:email]}\"|g' #{node['web_app']['system']['dir']}/db/migrate/001_setup.rb"
end

execute "seed lang" do
  command "sed -i 's|:language => \"en\"|:language => \"ru\"|g' #{node['web_app']['system']['dir']}/db/migrate/001_setup.rb"
end

execute "rake db:migrate RAILS_ENV='production'" do
  user "www-data"
  cwd "#{node['web_app']['system']['dir']}"
  not_if { ::File.exists?("#{node['web_app']['system']['dir']}/db/schema.rb") }
end


directory "#{node['web_app']['system']['dir']}/tmp" do
  action :create
  owner "www-data"
  group "www-data"
end

directory "#{node['web_app']['system']['dir']}/public/plugin_assets" do
  action :create
  owner "www-data"
  group "www-data"
end

directory "#{node['web_app']['system']['dir']}/tmp/pids" do
  action :create
  owner "www-data"
  group "www-data"
end

package "ruby1.8-dev"
package "libmysqlclient-dev"
package "g++"
package "thin"

execute "ruby-modules" do
  command "gem install mysql --include-dependencies"
end

execute "bundle-modules" do
  cwd "#{node['web_app']['system']['dir']}"
  command "rake gems:install RAILS_ENV=production"
end

execute "samples" do
  cwd "#{node['web_app']['system']['dir']}"
  command "rake redmine:load_default_data RAILS_ENV=production REDMINE_LANG=ru"
end

template "/etc/init.d/thin" do
  mode 0755
  owner "root"
  group "root"
  source "thin.erb"
  backup 0
end

execute "thin-rc.d" do
  command "/usr/sbin/update-rc.d -f thin defaults"
end

directory "/etc/thin" do
  action :create
  recursive true
end

file "/etc/thin/redmine.yml" do
  content "
user: www-data
group: www-data
chdir: #{node['web_app']['system']['dir']}
log: log/redmine.thin.log
socket: /tmp/redmine.sock
pid: tmp/pids/redmine.pid

environment: production
timeout: 30
max_conns: 1024

max_persistent_conns: 512
no-epoll: true
servers: 1
daemonize: 1"
end


service "thin" do
  start_command "/usr/sbin/invoke-rc.d thin start && sleep 1"
  stop_command "/usr/sbin/invoke-rc.d thin stop && sleep 1"
  restart_command "/usr/sbin/invoke-rc.d thin restart && sleep 1"
  reload_command "/usr/sbin/invoke-rc.d thin reload && sleep 1"
  supports value_for_platform(
    "default" => { "default" => [:restart, :reload ] }
  )
  action :start
end


nginx_conf "redmine" do
  cookbook "redmine"
end

nginx_site "default" do
  action "delete"
  disable true
end

nginx_site "#{node[:web_app][:system][:name]}.conf" do
  cookbook "redmine"
  action "create"
  source "redmine-nginx.conf.erb"
  enable true
  vars (:cache => false, :name => "#{node[:web_app][:system][:name]}", :docroot => "#{node['web_app']['system']['dir']}", :server_name => "#{node['hostname']}.clodo.ru", :server_aliases => "#{node['web_app']['ui']['domain']} www.#{node['web_app']['ui']['domain']}")
end


