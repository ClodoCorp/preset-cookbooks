case platform
when "debian","ubuntu"
  set['nginx']['dir]     = "/etc/nginx"
  set['nginx']['log_dir'] = "/var/log/nginx"
  set['nginx']['user']    = "www-data"
  set['nginx']['binary']  = "/usr/sbin/nginx"
else
  set['nginx']['dir']     = "/etc/nginx"
  set['nginx']['log_dir'] = "/var/log/nginx"
  set['nginx']['user']    = "www-data"
  set['nginx']['binary']  = "/usr/sbin/nginx"
end

default['nginx']['gzip'] = "on"
default['nginx']['gzip_http_version'] = "1.0"
default['nginx']['gzip_comp_level'] = "5"
default['nginx']['gzip_proxied'] = "any"
default['nginx']['gzip_types'] = [
  "text/plain",
  "text/css",
  "application/x-javascript",
  "application/xhtml+xml",
  "text/xml",
  "application/xml",
  "application/xml+rss",
  "text/javascript",
  "application/javascript"
]
default['nginx']['keepalive']          = "on"
default['nginx']['keepalive_timeout']  = 65
default['nginx']['worker_processes']   = cpu[:total]
default['nginx']['worker_connections'] = 2048
default['nginx']['worker_rlimit_nofile'] = node['nginx']['worker_connections'].to_i * node['nginx']['worker_processes'].to_i
default['nginx']['server_names_hash_bucket_size'] = 128
