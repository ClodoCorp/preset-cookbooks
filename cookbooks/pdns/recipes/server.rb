#
# Cookbook Name:: pdns
# Recipe:: server
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "pdns::#{node['pdns']['server_backend']}"

package "pdns" do
  package_name value_for_platform(
    ["debian","ubuntu"] => { "default" => "pdns-server" },
    "default" => "pdns"
  )
end

service "pdns" do
  action [:enable, :start]
end

case node["platform"]
when "arch"
  user "pdns" do
    shell "/bin/false"
    home "/var/spool/powerdns"
    supports :manage_home => true
    system true
  end
end

template "/etc/powerdns/pdns.d/preset.conf" do
  source "pdns.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[pdns]", :immediately
end

cookbook_file "/etc/rsyslog.d/#{node[:web_app][:system][:name]}.conf" do
  source "rsyslog.conf"
  owner "root"
  group "root"
  mode 0644
end

execute "reload rsyslog hack" do
  command "service rsyslog restart"
end


if node["web_app"]["ui"]["master"] != ""

  cron "#{node[:web_app][:system][:name]}-slaveclean.sh" do
    hour "23"
    minute "10"
    command "/usr/bin/pdns_server_slave_clean"
  end

  cookbook_file "/usr/bin/#{node[:web_app][:system][:name]}_server_slave_clean" do
    source "clean.sh"
    owner "root"
    group "root"
    mode 0700
  end
  execute "set supermaster" do
    command "mysql -uroot -p#{node['web_app']['system']['pass']} -D#{node['web_app']['system']['name']} -e \"insert into supermasters (ip, nameserver, account) values ('#{node['web_app']['ui']['master']}', '#{node['web_app']['ui']['ns']}', 'system');\""
  end
end

