include_recipe "apt"

apt_repository "ajenti" do
  uri "http://repo.ajenti.org/debian"
  distribution "main"
  components ["main"]
  key "http://repo.ajenti.org/debian/key"
  action :add
end

package "ajenti"

