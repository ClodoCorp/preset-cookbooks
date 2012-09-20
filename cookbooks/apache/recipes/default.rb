#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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

node['apache']['contact'] = node['web_app']['ui']['email']

class Chef::Recipe::Config_apache2        # add class
  include Config_apache2          # mix module config.rb from libraries
end

def retvar(val, vdef)
   if (defined?(val)).nil?
      vdef = val
   else
      val =  vdef
   end
   return val
end

def set_vars(value)
   $max_memory          = value

   mc = Chef::Recipe::Config_apache2.new($max_memory, $max_memory, (node['php']['memory_limit']).to_i + 10*1024*1024)
   node['apache']['start_servers'] = retvar(node['apache']['start_servers'], mc.start_servers)
   node['apache']['min_spare_servers'] = retvar(node['apache']['min_spare_servers'], mc.min_spare_servers)
   node['apache']['max_spare_servers'] = retvar(node['apache']['max_spare_servers'], mc.max_spare_servers)
   node['apache']['server_limit'] = retvar(node['apache']['server_limit'], mc.server_limit)
   node['apache']['max_clients'] = retvar(node['apache']['max_clients'], mc.max_clients)
   node['apache']['max_requests_per_child'] = retvar(node['apache']['max_requests_per_child'], mc.max_requests_per_child)
   mc = nil
end

set_vars(40)

package "apache2" do
  case node['platform']
  when "redhat","centos","scientific","fedora","suse","amazon"
    package_name "httpd"
  when "debian","ubuntu"
    package_name "apache2"
  when "arch"
    package_name "apache"
  end
  action :install
end

template "#{node['php']['conf_dir']}/php.ini" do
  cookbook "php"
  action :nothing
end

service "apache2" do
  case node['platform']
  when "redhat","centos","scientific","fedora","suse"
    service_name "httpd"
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command "/sbin/service httpd restart && sleep 1"
    reload_command "/sbin/service httpd reload && sleep 1"
  when "debian","ubuntu"
    service_name "apache2"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
    reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  when "arch"
    service_name "httpd"
  end
  supports value_for_platform(
    "debian" => { "4.0" => [ :restart, :reload ], "default" => [ :restart, :reload, :status ] },
    "ubuntu" => { "default" => [ :restart, :reload, :status ] },
    "redhat" => { "default" => [ :restart, :reload, :status ] },
    "centos" => { "default" => [ :restart, :reload, :status ] },
    "scientific" => { "default" => [ :restart, :reload, :status ] },
    "fedora" => { "default" => [ :restart, :reload, :status ] },
    "arch" => { "default" => [ :restart, :reload, :status ] },
    "suse" => { "default" => [ :restart, :reload, :status ] },
    "default" => { "default" => [:restart, :reload ] }
  )
  action :enable
  subscribes :restart, resources(:template => "#{node['php']['conf_dir']}/php.ini"), :immediately
end

if platform?("redhat", "centos", "scientific", "fedora", "arch", "suse" )
  directory node['apache']['log_dir'] do
    mode 0755
    action :create
  end

  package "perl"

  cookbook_file "/usr/local/bin/apache2_module_conf_generate.pl" do
    source "apache2_module_conf_generate.pl"
    mode 0755
    owner "root"
    group "root"
  end

  case node['platform']
    when "redhat","centos","scientific","fedora","suse"
      %w{sites-available sites-enabled mods-available mods-enabled}.each do |dir|
        directory "#{node['apache']['dir']}/#{dir}" do
          mode 0755
          owner "root"
          group "root"
          action :create
        end
      end
  end

  execute "generate-module-list" do
    if node['kernel']['machine'] == "x86_64"
      libdir = value_for_platform("arch" => { "default" => "lib" }, "default" => "lib64")
    else
      libdir = "lib"
    end
    command "/usr/local/bin/apache2_module_conf_generate.pl /usr/#{libdir}/httpd/modules /etc/httpd/mods-available"
    action :run
  end

  case node[:platform]
    when "redhat","centos","scientific","fedora","suse"
      %w{a2ensite a2dissite a2enmod a2dismod}.each do |modscript|
        template "/usr/sbin/#{modscript}" do
          source "#{modscript}.erb"
          mode 0755
          owner "root"
          group "root"
        end
      end
    end
  end
  # installed by default on centos/rhel, remove in favour of mods-enabled
  %w{ proxy_ajp auth_pam authz_ldap webalizer ssl welcome }.each do |f|
    file "#{node['apache']['dir']}/conf.d/#{f}.conf" do
      action :delete
      backup false
    end
  end

  # installed by default on centos/rhel, remove in favour of mods-enabled
  file "#{node['apache']['dir']}/conf.d/README" do
    action :delete
    backup false
  end

directory "#{node['apache']['dir']}/ssl" do
  action :create
  mode 0755
  owner "root"
  group "root"
end

directory "#{node['apache']['dir']}/conf.d" do
  action :create
  mode 0755
  owner "root"
  group "root"
end

directory node['apache']['cache_dir'] do
  action :create
  mode 0755
  owner "root"
  group "root"
end

template "apache2.conf" do
  case node['platform']
  when "redhat", "centos", "scientific", "fedora", "arch"
    path "#{node['apache']['dir']}/conf/httpd.conf"
  when "debian","ubuntu"
    path "#{node['apache']['dir']}/apache2.conf"
  end
  source "apache2.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "apache2")
end

template "security" do
  path "#{node['apache']['dir']}/conf.d/security"
  source "security.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  notifies :restart, resources(:service => "apache2")
end

template "charset" do
  path "#{node['apache']['dir']}/conf.d/charset"
  source "charset.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  notifies :restart, resources(:service => "apache2")
end

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  owner "root"
  group "root"
  variables (:apache_listen_ports => node['apache']['listen'], :apache_listen_sslports => node['apache']['listen_ssl'])
  mode 0644
  notifies :restart, resources(:service => "apache2")
end

template "#{node['apache']['dir']}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "apache2")
end

include_recipe "apache::mod_status"
include_recipe "apache::mod_alias"
include_recipe "apache::mod_auth_basic"
include_recipe "apache::mod_authn_file"
include_recipe "apache::mod_authz_default"
include_recipe "apache::mod_authz_groupfile"
include_recipe "apache::mod_authz_host"
include_recipe "apache::mod_authz_user"
include_recipe "apache::mod_autoindex"
include_recipe "apache::mod_dir"
include_recipe "apache::mod_env"
include_recipe "apache::mod_mime"
include_recipe "apache::mod_negotiation"
include_recipe "apache::mod_setenvif"
include_recipe "apache::mod_rewrite"
include_recipe "apache::mod_log_config" if platform?("redhat", "centos", "scientific", "fedora", "suse", "arch")


apache_site "default" if platform?("redhat", "centos", "scientific", "fedora")

service "apache2" do
  action :start
end