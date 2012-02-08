include_recipe "joomla"
include_recipe "chef::depends"
include_recipe "hosts"

hosts "127.0.0.1" do
  action "add"
  host "#{node['web_app']['ui']['domain']}"
end

ruby_block "setup" do
  block do
    Gem.clear_paths
    require 'curb'

    timeout = 20
    host = "localhost:80"
    real_host = "#{node['web_app']['ui']['domain']}"
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
      c.url = "http://#{host}/installation/index.php"
      c.http_get
      Chef::Log.info "get1: #{c.body_str}"
      c.url = "http://#{host}/installation/index.php?view=preinstall"
      c.http_get
      Chef::Log.info "get2: #{c.body_str}"
      spoof = c.body_str.match('name="([a-zA-z0-9]{32})"')[1]
      Chef::Log.info "spoof: #{spoof}"
      c.http_post("jform[language]=ru-RU", "task=setup.setlanguage", "#{spoof}=1")
      c.perform
      sleep(2)
      Chef::Log.info "get2: #{c.body_str}"
      if c.response_code == 200
        Chef::Log.info "Step 1 success!"
	c.url = "http://#{host}/installation/index.php?view=license"
	c.http_post("task=", "#{spoof}=1")
	c.perform
	sleep(2)
	c.url = "http://#{host}/installation/index.php?view=database"
	c.http_get
#	c.url = "http://#{host}/installation/index.php?view=database"
#	c.http_post("task=", "#{spoof}=1")
#	c.perform
#	sleep(2)
	c.url = "http://#{host}/installation/index.php?view=database"
	c.http_post("task=setup.database", "#{spoof}=1", "jform[db_type]=mysql", "jform[db_host]=localhost", "jform[db_user]=#{node['web_app']['system']['name']}",
		    "jform[db_pass]=#{node['web_app']['system']['pass']}", "jform[db_name]=#{node['web_app']['system']['name']}", "jform[db_prefix]=jmc_", "jform[db_old]=remove")
	c.perform
	sleep(2)
	c.url = "http://#{host}/installation/index.php?view=filesystem"
	c.http_post("task=setup.filesystem", "#{spoof}=1", "jform[ftp_enable]=0", "jform[ftp_user]=", "jform[ftp_pass]=",
		    "jform[ftp_root]=", "jform[ftp_host]=127.0.0.1", "jform[ftp_port]=21", "jform[ftp_save]=0")
	c.perform
	sleep(2)
	c.url = "http://#{host}/installation/index.php?view=site"
	c.http_get
	c.http_post("task=setup.saveconfig", "#{spoof}=1", "jform[site_name]=#{node['web_app']['ui']['title']}", "jform[site_metadesc]=", "jform[site_metakeys]=",
		    "jform[admin_email]=#{node['web_app']['ui']['email']}", "jform[admin_user]=#{node['web_app']['ui']['login']}", 
		    "jform[admin_password]=#{node['web_app']['ui']['pass']}", "jform[admin_password2]=#{node['web_app']['ui']['pass']}", "jform[sample_installed]=0")
	c.perform
	sleep(2)
	c.url = "http://#{host}/installation/index.php?view=complete"
	c.http_get
	Chef::Log.info "get3: #{c.body_str}"
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

directory "#{node['web_app']['system']['dir']}/installation" do
  recursive true
  action :delete
end

