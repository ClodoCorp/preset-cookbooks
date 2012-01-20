include_recipe "modx"
include_recipe "chef::depends"

ruby_block "setup" do
  block do
    Gem.clear_paths
    require 'curb'

    timeout = 20
    host = "localhost:80"
    real_host = "#{node['web_app']['ui']['domain']}"
    Chef::Log.info "call get on #{host}, maximal request time: #{timeout} seconds"
    c = Curl::Easy.new() do |curl|
      curl.url = "http://#{host}/setup/"
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
      c.url = "http://#{host}/setup/index.php?s=set"
      c.http_get
      Chef::Log.info "get1: #{c.body_str}"

      c.url = "http://#{host}/setup/?"
      c.http_post("language=ru", "proceed=Select")
      c.perform
      sleep(2)
      Chef::Log.info "get2: #{c.body_str}"
      if c.response_code == 200
        Chef::Log.info "Step 1 success!"
	c.url = "http://#{host}/setup/?action=welcome"
	c.http_post("proceed=Далее")
	c.perform
	c.url = "http://#{host}//setup/?action=options"
	c.http_post("installmode=0", "new_folder_permissions=0755", "new_file_permissions=0644", "unpacked=1", "proceed=Далее")
	c.perform
	Chef::Log.info "get3: #{c.body_str}"

        c.url = "http://#{host}/setup/?action=database"
	c.http_post("database_type=mysql", "database_server=localhost", "database_user=#{node[:web_app][:system][:name]}",
		    "database_password=#{node[:web_app][:system][:pass]}", "dbase=#{node[:web_app][:system][:name]}",
		    "table_prefix=pref_", "database_connection_charset=utf8", "database_collation=utf8_general_ci",
		    "cmsadmin=#{node[:web_app][:ui][:login]}", "cmsadminemail=#{node[:web_app][:ui][:email]}",
		    "cmspassword=#{node[:web_app][:ui][:pass]}", "cmspasswordconfirm=#{node[:web_app][:ui][:pass]}",
		    "unpacked=1", "proceed=Далее")
	c.perform
	Chef::Log.info "get4: #{c.body_str}"
	c.url = "http://#{host}/setup/?action=summary"
	c.http_post("proceed=Установить")
	c.perform
	Chef::Log.info "get5: #{c.body_str}"
	c.url = "http://#{host}/setup/?action=install"
	c.http_post("proceed=Далее")
	c.perform
	Chef::Log.info "get6: #{c.body_str}"
	c.url = "http://#{host}/setup/?action=complete"
	c.http_post("cleanup=1", "proceed=Войти")
	c.perform
	Chef::Log.info "get7: #{c.body_str}"
      else
	 Chef::Log.error "Step 1 failed!"
      end
    else
      Chef::Log.error "GET failed!"
    end
    c.close()
  end
  action :create
end

execute "htaccess" do
  user "www-data"
  group "www-data"
  command "mv -f #{node[:web_app][:system][:dir]}/ht.access #{node[:web_app][:system][:dir]}/.htaccess"
end
