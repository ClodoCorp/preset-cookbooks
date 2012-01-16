#libcurl4-gnutls-dev
%w{ruby1.8-dev make gcc libcurl4-openssl-dev}.each do |pkg|
  package "#{pkg}" do
    action :install
  end
end

gem_package "curb" do
  action :install
end


