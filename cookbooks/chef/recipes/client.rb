service "chef-client" do
  supports :status => true, :restart => true
  action :nothing
end

