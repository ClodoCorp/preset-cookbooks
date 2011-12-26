include_recipe "rails"

ruby_block "reset group list" do
  block do
    Etc.endgrent
  end
  action :nothing
end

user "git" do
  uid 601
  gid "root"
  shell "/bin/sh"
  system "true"
  comment "git Version Control User"
  supports :manage_home => true
  home "/home/git"
  notifies :create, "ruby_block[reset group list]", :immediately
end

user "gitlabhq" do
  uid 600
  gid "root, git"
  shell "/bin/bash"
  password `openssl passwd -1 #{node['system']['pass']}`
  comment "GitLabHQ Admin User"
  supports :manage_home => true
  home "/home/gitlabhq"
  notifies :create, "ruby_block[reset group list]", :immediately
end

%w{gitolite python-dev python-pip git-core git-svn sendmail zlib1g ssh openssl git-core wget curl gcc checkinstall libxml2-dev libxslt-dev sqlite3 libsqlite3-dev libcurl4-openssl-dev libc6-dev libssl-dev libmysql++-dev make build-essential zlib1g-dev postfix ruby1.9 openssh-server rubygems libdaemons-ruby nginx}.each do |pkg|
  package "#{pkg}"
end

execute "gitconfig-name" do
  command "su -l gitlabhq -c 'git config --global user.name \"Vasiliy Tolstov\"'"
end

execute "gitconfig-email" do
  command "su -l gitlabhq -c 'git config --global user.email \"gitlabhq@#{node['system']['ui']['domain']}\"'"
end

directory "/home/gitlabhq/.ssh" do
  action :create
  recursive true
end

execute "ssh-keys" do
  command "su -l gitlabhq 'ssh-keygen -b 4096 -f /home/gitlabhq/.ssh/id_rsa -t rsa -N \'\''"
end

file "/home/git/rails.pub" do
  content "/home/gitlabhq/.ssh/id_rsa.pub"
  provider Chef::Provider::File::Copy
end


git "/home/git/gitolite" do
  repository "git@github.com:gitlabhq/gitolite.git"
  action :sync
  user "git"                                    
  group "git"
end

execute "gl-install" do
  user "git"
  group "git"
  command "/home/git/gitolite/src/gl-system-install"
end

execute "gl-setup" do
  user "git"
  group "git"
  command "PATH=/home/git/bin:$PATH; gl-setup /home/git/rails.pub"
end

execute "owner" do
  command "chown -R git:git /home/git/repositories/"
end

execute "mode" do
  command "chmod -R g+rwX /home/git/repositories/; chmod g+r /home/git"
end

REPO_UMASK = 0007;

execute "ssh-login" do
  command "su -l gitlabhq -c 'ssh -o StrictHostKeyChecking=none gitlabhq@localhost'"
end

execute "python-modules" do
  command "pip install pygments"
end

execute "ruby-modules" do
  command "gem install rails bundler --include-dependencies"
end

git "#{node['web_app']['system']['dir']}" do
  repository "git@github.com:gitlabhq/gitlabhq.git"
  action :sync
  user "gitlabhq"
  group "gitlabhq"
end

execute "bundle-modules" do
  cwd "#{node['web_app']['system']['dir']}"
  command "bundle install --without development test"
end

execute "rake-setup" do
  user "gitlabhq"
  group "gitlabhq"
  command "bundle exec rake db:setup RAILS_ENV=production"
end

execute "rake-seed_fu" do
  user "gitlabhq"
  group "gitlabhq"
  command "bundle exec rake db:seed_fu RAILS_ENV=production"
end

execute "thin" do
  command "thin install"
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


file "/etc/thin/gitlabhq.yml" do
  content "
user: gitlabhq
group: gitlabhq
chdir: /home/gitlabhq/gitlabhq/
log: log/gitlabhq.thin.log
socket: /tmp/gitlab.sock
pid: tmp/pids/gitlab.pid

environment: production
timeout: 30
max_conns: 1024

max_persistent_conns: 512
no-epoll: true
servers: 1
daemonize: 1"
end

execute "Gemfile" do
  command "sed -i 's///g' /home/gitlab/gitlabhq/Gemfile"
end

