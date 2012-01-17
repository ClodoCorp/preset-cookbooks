
directory "/etc/chef" do
  mode 0700
end

template "/etc/chef/solo.rb" do
  source "solo.erb"
  mode 0600
end

execute "chef-solo" do
  command "chef-solo -c /etc/chef/solo.rb -l debug"
end

