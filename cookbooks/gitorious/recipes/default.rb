include_recipe "rails"

%w{ libmysql-ruby imagemagick git-core git-svn apg libpcre3 sendmail zlib1g ssh memcached geoip-bin libgeoip1 uuid openjdk-6-jre curl openssl }.each do |pkg|
  package "#{pkg}"
end
#ultrasphinx
%w{ librmagick-ruby rubygems stopmpserver libchronic-ruby libmime-types-ruby libhmac-ruby libdaemons-ruby libbluecloth-ruby libyadis-ruby libopenid-ruby librspec-ruby libredcloth-ruby }.each do |pkg|
  package "#{pkg}"
end
