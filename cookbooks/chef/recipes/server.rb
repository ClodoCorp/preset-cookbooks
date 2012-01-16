include_recipe "chef::depends"


package "chef-solr" do
  response_file "chef-solr.seed.erb"
end

package "chef-server"

package "chef-server-webui" do
  response_file "chef-server-webui.seed.erb"
end


service "chef-client" do
  action :restart
end

execute "knife setup" do
  environment ({'HOME' => '/root'})
  command "knife configure -i --yes --verbose --print-after --user knife --no-editor --no-color --server-url http://localhost:4000  --defaults --repository /var/chef/"
end

execute "setup create" do
  environment ({'HOME' => '/root'})
  command "knife client create admin --admin --no-color --no-editor --print-after --verbose --yes"
end

execute "knife test" do
  environment ({'HOME' => '/root'})
  command "knife node list"
end

ruby_block "user remove" do
  block do
    Gem.clear_paths
    require 'curb'

    timeout = 600
    host = "localhost:4040"
    real_host = "localhost"
    Chef::Log.info "call get on #{host}, maximal request time: #{timeout} seconds"
    c = Curl::Easy.new() do |curl|
      curl.url = "http://#{host}/"
      curl.headers['Host'] = real_host
      curl.verbose = true
      curl.follow_location = true
      curl.enable_cookies = true
      curl.cookiefile = "/tmp/cookie.txt"
      curl.timeout = timeout
    end
    c.perform
    if c.response_code == 200
      Chef::Log.info "GET success!"
      c.url = "http://#{host}/users/login_exec"
      c.http_post("name=admin", "password=p@ssw0rd1", "submit=login")
      c.perform
      if c.response_code == 200
        Chef::Log.info "Login success!"
	if "#{node[:web_app][:ui][:login]}" == "admin"
	  Chef::Log.info "Update admin user"
          c.url = "http://#{host}/users/admin/edit"
	  c.http_get
	  c.url = "http://#{host}/users/admin/update"
	  c.http_post("new_password=#{node[:web_app][:ui][:pass]}", "confirm_new_password=#{node[:web_app][:ui][:pass]}",
  		      "openid=#{node[:web_app][:ui][:openid]}", "submit=Save User", "_method=put")
          if c.response_code == 200
	    Chef::Log.info "Update success!"
	  else
	    Chef::Log.error "Update failed! #{c.body_str}"

	  end
	else
	  Chef::Log.info "Create admin user"
	  c.url = "http://#{host}/users/new"
	  c.http_get
	  c.url = "http://#{host}/users/create"
	  c.http_post("name=#{node[:web_app][:ui][:login]}", "password=#{node[:web_app][:ui][:pass]}", "password2=#{node[:web_app][:ui][:pass]}",
	              "admin=1", "openid=#{node[:web_app][:ui][:openid]}", "submit=Create")
	  c.perform
	  if c.response_code == 200
	    Chef::Log.info "Create success!"
	    c.url = c.last_effective_url
	    c.http_get
	    if c.response_code == 200
              c.url = "http://#{host}/users/admin/delete"
	      c.http_post("_method=delete")
	      if c.response_code == 200
	        Chef::Log.info "Delete success!"
	      else
	        Chef::Log.error "Delete failed!"
	      end
	    end
	  else
	    Chef::Log.error "Create failed!"
	  end
	end
      else
	 Chef::Log.error "Login failed!"
      end
    else
      Chef::Log.error "GET failed!"
    end
    c.close()
  end
  action :create
end

