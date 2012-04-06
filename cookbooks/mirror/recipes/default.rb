
remote_file "#{Chef::Config[:file_cache_path]}/go.go1.linux-amd64.tar.gz" do
  source "http://go.googlecode.com/files/go.go1.linux-amd64.tar.gz"
  mode "0644"
end

execute "unpack" do
  cwd "/usr/local"
  command "tar -zxf #{Chef::Config[:file_cache_path]}/go.go1.linux-amd64.tar.gz"
  creates "/usr/local/go"
end

package "git-core"

execute "install" do
  environment ({'PATH' => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/go/bin', 'GOBIN' => '/usr/sbin', 'GOPATH' => '/root/go'})
  cwd "/root"
  command "go get -u -v -x bitbucket.org/vase/pkgcached"
end

execute "init" do
  command "cp -f /root/go/src/bitbucket.org/vase/pkgcached/pkgcached.init /etc/init.d/pkgcached"
end

execute "perm" do
  command "chmod +x /etc/init.d/pkgcached"
end

execute "conf" do
  command "cp -f /root/go/src/bitbucket.org/vase/pkgcached/pkgcached.json /etc/pkgcached.json"
end

execute "defaults" do
  command "update-rc.d pkgcached defaults"
end

execute "restart" do
  command "service pkgcached restart"
end

