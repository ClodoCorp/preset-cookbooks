maintainer       "Barry Steinglass"
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures livestreet"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.8.4"

%w{apache nginx hosts chef php openssl mysql sphinx}.each do |cb|
  depends cb
end

%w{ debian ubuntu }.each do |os|
  supports os
end

