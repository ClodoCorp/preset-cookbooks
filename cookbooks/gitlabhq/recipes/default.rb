include_recipe "rails"
include_recipe "nginx"

ruby_block "reset group list" do
  block do
    Etc.endgrent
  end
  action :nothing
end

%w{gitolite python-dev python-pip git-core git-svn sendmail zlib1g ssh openssl git-core wget curl gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev postfix ruby1.9.1 openssh-server rubygems ruby1.9.1-dev}.each do |pkg|
  package "#{pkg}"
end


gem_package("daemons") do
  gem_binary("/usr/bin/gem1.9.1")
  version "1.1.4"
  action :install
#  options("--prerelease --no-format-executable")
end

#package "daemons" do
#  version "1.1.4"
#  action :install
#  gem_binary "gem1.9.1"
#  provider Chef::Provider::Package::Rubygems
#end

group "git" do
  action :create
end

group "gitlabhq" do
  action :create
end


user "git" do
  gid "git"
  shell "/bin/sh"
  system true
  comment "git Version Control User"
  supports :manage_home => true
  home "/home/git"
  notifies :create, "ruby_block[reset group list]", :immediately
end

user "gitlabhq" do
  gid "gitlabhq"
  shell "/bin/bash"
#  password `openssl passwd -1 #{node['web_app']['system']['pass']}`
  comment "GitLabHQ Admin User"
  supports :manage_home => true
  home "/home/gitlabhq"
  notifies :create, "ruby_block[reset group list]", :immediately
end

group "git" do
  action :modify
  members ['git', 'gitlabhq']
end

execute "gitconfig-name" do
  user "gitlabhq"
  group "gitlabhq"
  environment ({'HOME' => '/home/gitlabhq'})
  cwd "/home/gitlabhq"
  command "git config --global user.name \"Vasiliy Tolstov\""
end

execute "gitconfig-email" do
  user "gitlabhq"
  group "gitlabhq"
  environment ({'HOME' => '/home/gitlabhq'})
  cwd "/home/gitlabhq"
  command "git config --global user.email \"gitlabhq@#{node['web_app']['ui']['domain']}\""
end

directory "/home/gitlabhq/.ssh" do
  action :create
  recursive true
  owner "gitlabhq"
  group "gitlabhq"
end

execute "ssh-keys" do
  user "gitlabhq"
  group "gitlabhq"
  environment ({'HOME' => '/home/gitlabhq'})
  cwd "/home/gitlabhq"
  command "ssh-keygen -q -b 4096 -f /home/gitlabhq/.ssh/id_rsa -t rsa -N \"\""
  not_if do ::File.exists?("/home/gitlabhq/.ssh/id_rsa") end
end

file "/home/git/rails.pub" do
  content "/home/gitlabhq/.ssh/id_rsa.pub"
  provider Chef::Provider::File::Copy
end


git "/home/git/gitolite" do
  repository "git://github.com/gitlabhq/gitolite.git"
  action :sync
  user "git"
  group "git"
end

execute "gl-install" do
  user "git"
  group "git"
  environment ({'HOME' => '/home/git', 'PATH' => '/home/git/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin'})
  cwd "/home/git"
  command "/home/git/gitolite/src/gl-system-install"
end

template "/home/git/.gitolite.rc" do
  source "gitolite.rc.erb"
end

execute "gl-setup" do
  user "git"
  group "git"
  environment ({'HOME' => '/home/git', 'PATH' => '/home/git/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin'})
  cwd "/home/git"
  command "gl-setup -q /home/git/rails.pub"
end

directory "/home/git/repositories/" do
  action :create
  recursive true
  owner "git"
  group "git"
end

execute "mode" do
  command "chmod -R g+rwX /home/git/repositories/; chmod g+r /home/git"
end


execute "python-modules" do
  command "pip install pygments"
end

file "/root/.gemrc" do
  content "
---
:update_sources: true
:sources:
 - http://gems.rubyforge.org/
 - http://gems.github.com
:benchmark: false
:bulk_threshold: 1000
:backtrace: false
:verbose: true
gem: --no-ri --no-rdoc
install: --no-rdoc --no-ri
update:  --no-rdoc --no-ri
"
end


execute "ruby-update" do
  environment ({'REALLY_GEM_UPDATE_SYSTEM' => 'true'})
  command "gem1.9.1 update --system"
end

execute "ruby-modules" do
  command "gem1.9.1 install rails thin bundler --include-dependencies"
end

git "#{node['web_app']['system']['dir']}" do
  repository "git://github.com/gitlabhq/gitlabhq.git"
  action :sync
end

execute "fix-owner" do
  command "chown -R gitlabhq:gitlabhq #{node['web_app']['system']['dir']}"
end

directory "#{node['web_app']['system']['dir']}/tmp/pids" do
  action :create
  recursive true
  owner "gitlabhq"
  group "gitlabhq"
end


execute "bundle-modules" do
#  user "gitlabhq"
#  group "gitlabhq"
#  environment ({'HOME' => '/home/gitlabhq'})
  cwd "#{node['web_app']['system']['dir']}"
  command "bundle install --without development test"
end

execute "seeding-email" do
  command "sed \"s/admin@local.host/#{node['web_app']['ui']['email']}/g\" -i #{node['web_app']['system']['dir']}/db/fixtures/production/001_admin.rb"
end

execute "seeding-pass" do
  command "sed \"s/5iveL!fe/#{node['web_app']['ui']['pass']}/g\" -i #{node['web_app']['system']['dir']}/db/fixtures/production/001_admin.rb"
end

execute "seeding-name" do
  command "sed \"s/Administrator/#{node['web_app']['ui']['login']}/g\" -i #{node['web_app']['system']['dir']}/db/fixtures/production/001_admin.rb"
end

execute "rake-setup" do
  user "gitlabhq"
  group "gitlabhq"
  environment ({'HOME' => '/home/gitlabhq'})
  cwd "#{node['web_app']['system']['dir']}"
  command "bundle exec rake db:setup RAILS_ENV=production"
end

execute "rake-seed_fu" do
  user "gitlabhq"
  group "gitlabhq"
  environment ({'HOME' => '/home/gitlabhq'})
  cwd "#{node['web_app']['system']['dir']}"
  command "bundle exec rake db:seed_fu RAILS_ENV=production"
end

template "/etc/init.d/thin" do
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


file "/etc/thin/gitlabhq.yml" do
  content "
user: gitlabhq
group: gitlabhq
chdir: #{node['web_app']['system']['dir']}
log: log/gitlabhq.thin.log
socket: /tmp/gitlabhq.sock
pid: tmp/pids/gitlabhq.pid

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


nginx_conf "gitlabhq" do
  cookbook "gitlabhq"
end

nginx_site "gitlabhq.conf" do
  cookbook "gitlabhq"
  action "create"
  enable true
end

nginx_site "default" do
  action "delete"
  disable true
end

