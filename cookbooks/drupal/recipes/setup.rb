include_recipe "drupal"
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
      c.url = "http://#{host}/install.php?profile=default&locale=en"
      c.http_get
      Chef::Log.info "get1: #{c.body_str}"

      c.http_post("db_type=mysql", "db_path=#{node['web_app']['system']['name']}", "db_user=#{node['web_app']['system']['name']}",
		  "db_pass=#{node['web_app']['system']['pass']}", "db_host=localhost", "db_port=3306",
		  "db_prefix=", "op=Save and continue", "form_id=install_settings_form")
      c.perform
      sleep(2)
      Chef::Log.info "get2: #{c.body_str}"
      if c.response_code == 200
        Chef::Log.info "Step 1 success!"
	c.url = "http://#{host}/install.php?profile=default&locale=en&op=do_nojs&id=1"
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.http_get
	sleep(2)
	c.url = "http://#{host}/install.php?profile=default&locale=en&op=finished&id=1"
	c.http_get
	Chef::Log.info "get3: #{c.body_str}"

        c.url = "http://#{host}/install.php?profile=default&locale=en"
	c.http_post("site_name=#{node['web_app']['ui']['title']}", "site_mail=#{node['web_app']['ui']['email']}",
		    "account[name]=#{node['web_app']['ui']['login']}", "account[mail]=#{node['web_app']['ui']['email']}",
		    "account[pass][pass1]=#{node['web_app']['ui']['pass']}", "account[pass][pass2]=#{node['web_app']['ui']['pass']}",
		    "site_default_country=RU", "date_default_timezone=50400", "op=Save and continue",
		    "update_status_module[1]=1", "clean_url=1", "form_id=install_configure_form")
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

cron "#{node['web_app']['system']['name']}" do
  hour "*/1"
  minute "10"
  command "/usr/bin/wget -qO - http://#{node['web_app']['ui']['domain']}/cron.php"
end
