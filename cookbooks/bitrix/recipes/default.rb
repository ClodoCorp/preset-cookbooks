include_recipe "hosts"

hosts_host "127.0.0.1" do
  action :create
  hosts << node['web_app']['ui']['domain']
end


include_recipe value_for_platform(
    [ "centos", "redhat", "suse", "fedora" ] => { "default" => "bitrix::centos" },
    [ "debian", "ubuntu" ] => { "default" => "bitrix::debian" })

