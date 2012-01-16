case platform
when "redhat","centos","scientific","fedora","suse"
  set[:apache][:dir]     = "/etc/httpd"
  set[:apache][:log_dir] = "/var/log/httpd"
  set[:apache][:user]    = "apache"
  set[:apache][:group]   = "apache"
  set[:apache][:binary]  = "/usr/sbin/httpd"
  set[:apache][:icondir] = "/var/www/icons/"
  set[:apache][:cache_dir] = "/var/cache/httpd"
  if node.platform_version.to_f >= 6 then
    set[:apache][:pid_file] = "/var/run/httpd/httpd.pid"
  else
    set[:apache][:pid_file] = "/var/run/httpd.pid"
  end
  set[:apache][:lib_dir] = node[:kernel][:machine] =~ /^i[36]86$/ ? "/usr/lib/httpd" : "/usr/lib64/httpd"
when "debian","ubuntu"
  set[:apache][:dir]     = "/etc/apache2"
  set[:apache][:log_dir] = "/var/log/apache2"
  set[:apache][:user]    = "www-data"
  set[:apache][:group]   = "www-data"
  set[:apache][:binary]  = "/usr/sbin/apache2"
  set[:apache][:icondir] = "/usr/share/apache2/icons"
  set[:apache][:cache_dir] = "/var/cache/apache2"
  set[:apache][:pid_file]  = "/var/run/apache2.pid"
  set[:apache][:lib_dir] = "/usr/lib/apache2"
when "arch"
  set[:apache][:dir]     = "/etc/httpd"
  set[:apache][:log_dir] = "/var/log/httpd"
  set[:apache][:user]    = "http"
  set[:apache][:group]   = "http"
  set[:apache][:binary]  = "/usr/sbin/httpd"
  set[:apache][:icondir] = "/usr/share/httpd/icons"
  set[:apache][:cache_dir] = "/var/cache/httpd"
  set[:apache][:pid_file]  = "/var/run/httpd/httpd.pid"
  set[:apache][:lib_dir] = "/usr/lib/httpd"
else
  set[:apache][:dir]     = "/etc/apache2"
  set[:apache][:log_dir] = "/var/log/apache2"
  set[:apache][:user]    = "www-data"
  set[:apache][:group]   = "www-data"
  set[:apache][:binary]  = "/usr/sbin/apache2"
  set[:apache][:icondir] = "/usr/share/apache2/icons"
  set[:apache][:cache_dir] = "/var/cache/apache2"
  set[:apache][:pid_file]  = "logs/httpd.pid"
  set[:apache][:lib_dir] = "/usr/lib/apache2"
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default[:apache][:listen_ports] = [ "80" ]
default[:apache][:listen_sslports] = [ "443" ]
default[:apache][:contact] = "#{node['web_app']['ui']['email']}"
default[:apache][:timeout] = 300
default[:apache][:keepalive] = "On"
default[:apache][:keepaliverequests] = 100
default[:apache][:keepalivetimeout] = 5

# Security
default[:apache][:servertokens] = "Prod"
default[:apache][:serversignature] = "On"
default[:apache][:traceenable] = "Off"

# mod_auth_openids
default[:apache][:allowed_openids] = Array.new

# Prefork Attributes
default[:apache2][:start_servers] = 2
default[:apache2][:min_spare_servers] = 2
default[:apache2][:max_spare_servers] = 5
default[:apache2][:server_limit] = 100
default[:apache2][:max_clients] = 100
default[:apache2][:max_requests_per_child] = 1000

# Worker Attributes
default[:apache][:worker][:startservers] = 4
default[:apache][:worker][:maxclients] = 1024
default[:apache][:worker][:minsparethreads] = 64
default[:apache][:worker][:maxsparethreads] = 192
default[:apache][:worker][:threadsperchild] = 64
default[:apache][:worker][:maxrequestsperchild] = 0
