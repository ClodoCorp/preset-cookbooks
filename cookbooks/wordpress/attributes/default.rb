default['wordpress']['version'] = "3.2.1"
default['wordpress']['checksum'] = "21e3cebd02808f9ee39a979d22e6e10bce5356ddf7068aef182847b12c9b95a9"
default['wordpress']['dir'] = "/var/www/wordpress"
default['wordpress']['db']['database'] = "wordpressdb"
default['wordpress']['db']['user'] = "wordpressuser"
default['wordpress']['server_aliases'] = [node['fqdn']]
