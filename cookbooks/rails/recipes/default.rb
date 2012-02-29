package "rails"

%w{ /var/www }.each do |dir|
  directory "#{dir}" do
    action :create
    owner "root"
    group "root"
    mode 0755
    recursive true
  end
end

cookbook_file "/tmp/default.tar.gz" do
  backup 0
  source "default.tar.gz"
  cookbook "rails"
end

execute "rails-untar" do
  cwd "/var/www"
  command "tar -zxf /tmp/default.tar.gz"
  creates "/var/www/default/config/boot.rb"
end

file "/tmp/default.tar.gz" do
  action :delete
  backup 0
end

