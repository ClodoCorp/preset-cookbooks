#
# Cookbook Name:: pdns
# Recipe:: sqlite3
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

include_recipe "mysql::server"

package "pdns-backend-mysql" do
  package_name value_for_platform(
    "arch" => { "default" => "pdns" },
    ["debian","ubuntu"] => { "default" => "pdns-backend-mysql" },
    ["redhat","centos","fedora"] => { "default" => "pdns-backend-mysql" },
    "default" => "pdns-backend-mysql"
  )
  response_file "pdns-backend-mysql.erb"
end

directory "/var/lib/pdns"

cookbook_file "/tmp/pdns_schema.sql" do
  source "mysql-schema.sql"
end

mysql_db "#{node['web_app']['system']['name']}" do
  action "create"
end

mysql_grants "#{node['web_app']['system']['name']}" do
end

execute "load pdns schema" do
  command "/usr/bin/mysql -u root -p#{node['web_app']['system']['pass']} -D#{node['web_app']['system']['name']} < /tmp/pdns_schema.sql"
end
