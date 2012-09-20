maintainer        "Vasiliy Tolstov"
maintainer_email  "v.tolstov@go2clouds.org"
license           "Apache 2.0"
description       "Provides useful providers and libraries"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.0.1"

%w{ debian ubuntu centos suse fedora redhat }.each do |os|
  supports os
end

