maintainer       "Vasiliy Tolstov"
maintainer_email "v.tolstov@selfip.ru"
license          "Apache 2.0"
description      "Add host to /etc/hosts"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ debian ubuntu }.each do |os|
  supports os
end
