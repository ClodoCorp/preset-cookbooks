include_recipe "yum"

yum_repository "ajenti" do
  name "Ajenti"
  url "http://repo.ajenti.org/centos/"
  action :add
end

package "ajenti"
