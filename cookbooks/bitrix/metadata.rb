maintainer       "Vasiliy Tolstov"
maintainer_email "v.tolstov@selfip.ru"
license          "Apache 2.0"
description      "Installs/Configures bitrix-env"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

recipe "bitrix", "Installs and configures bitrix-env stack on a single system"

%w{apache mysql apt nginx}.each do |cb|
  depends cb
end

%w{ debian ubuntu }.each do |os|
  supports os
end
