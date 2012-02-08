include_recipe "acquia"
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
      c.url = "http://#{host}/install.php?profile=acquia&locale=en"
      c.http_get
      Chef::Log.info "get1: #{c.body_str}"
      c.http_post("driver=mysql", "mysql[database]=#{node['web_app']['system']['name']}", "mysql[username]=#{node['web_app']['system']['name']}",
		  "mysql[password]=#{node['web_app']['system']['pass']}", "mysql[host]=localhost", "mysql[port]=3306",
		  "mysql[db_prefix]=", "op=Save and continue", "form_id=install_settings_form")
      c.perform
      sleep(2)
      Chef::Log.info "get2: #{c.body_str}"
      if c.response_code == 200
        Chef::Log.info "Step 1 success!"
	c.url = "http://#{host}/install.php?locale=en&profile=acquia&op=start&id=1"
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	Chef::Log.info "get3: #{c.body_str}"

        c.url = "http://#{host}/install.php?profile=acquia&locale=en"
	c.http_post("site_name=#{node['web_app']['ui']['title']}", "site_mail=#{node['web_app']['ui']['email']}",
		    "account[name]=#{node['web_app']['ui']['login']}", "account[mail]=#{node['web_app']['ui']['email']}",
		    "account[pass][pass1]=#{node['web_app']['ui']['pass']}", "account[pass][pass2]=#{node['web_app']['ui']['pass']}",
		    "site_default_country=RU", "date_default_timezone=Europe/Moscow", "op=Save and continue",
		    "update_status_module[1]=1", "update_status_module[2]=2", "clean_url=1", "form_id=install_configure_form")
	c.perform
	Chef::Log.info "get4: #{c.body_str}"
	c.url = "http://#{host}/"
	c.http_get
	Chef::Log.info "get5: #{c.body_str}"
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

