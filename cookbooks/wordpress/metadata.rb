maintainer       "Barry Steinglass"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures wordpress"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.8.4"

recipe "wordpress", "Installs and configures wordpress LAMP stack on a single system"

%w{ nginx chef hosts apache2 mysql php openssl }.each do |cb|
  depends cb
end

%w{ debian ubuntu }.each do |os|
  supports os
end
