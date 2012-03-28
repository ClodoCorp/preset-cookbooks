maintainer       "Vasiliy Tolstov"
maintainer_email "v.tolstov@selfip.ru"
license          "Apache 2.0"
description      "Installs/Configures joomla"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.8.4"

recipe "joomla", "Installs and configures joomla on a single system"

%w{ php }.each do |cb|
  depends cb
end

depends "apache2", ">= 0.99.4"
depends "mysql", ">= 1.0.5"

%w{ debian ubuntu }.each do |os|
  supports os
end

