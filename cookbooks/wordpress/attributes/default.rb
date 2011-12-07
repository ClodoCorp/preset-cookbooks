::Chef::Node.send(:include, Opscode::OpenSSL::Password)

default['wordpress']['keys']['auth'] = secure_password
default['wordpress']['keys']['secure_auth'] = secure_password
default['wordpress']['keys']['logged_in'] = secure_password
default['wordpress']['keys']['nonce'] = secure_password

