include_recipe "chef"

pkgs = %{ chef libjson-ruby1.8 libnet-ssh-gateway-ruby1.8 libmixlib-authentication-ruby1.8 ohai libtreetop-ruby libmixlib-log-ruby1.8 rubygems libnet-ssh2-ruby1.8 libpolyglot-ruby libmoneta-ruby libmime-types-ruby librestclient-ruby1.8 libbunny-ruby ruby1.8 ruby librestclient-ruby liberubis-ruby1.8 libsystemu-ruby1.8 libjson-ruby libmixlib-config-ruby libohai-ruby libuuidtools-ruby1.8 libhighline-ruby1.8 libabstract-ruby1.8 libmixlib-authentication-ruby libmixlib-config-ruby1.8 libnet-ssh-multi-ruby libmixlib-log-ruby libuuidtools-ruby libnet-ssh2-ruby libnet-ssh-multi-ruby1.8 libhighline-ruby rubygems1.8 libbunny-ruby1.8 libmixlib-cli-ruby libruby1.8 libmixlib-cli-ruby1.8 libyajl-ruby libmoneta-ruby1.8 libohai-ruby1.8 liberubis-ruby }

cmds = %{ "rm -rf /var/chef" }

chef_purge do
  clean true
  packages << pkgs
  commands << cmds
end

