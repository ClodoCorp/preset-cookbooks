include_recipe "wordpress"
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
      curl.url = "http://#{host}/"
      curl.headers['Host'] = real_host
      curl.verbose = true
      curl.follow_location = true
      curl.enable_cookies = true
      curl.cookiefile = "/tmp/cookie.txt"
      curl.timeout = timeout
    end
    c.perform
    if c.response_code == 200 or c.response_code == 500
      Chef::Log.info "GET success!"
      c.url = "http://#{host}/wp-admin/setup-config.php"
      c.http_get
      Chef::Log.info "get1: #{c.body_str}"
      c.url = "http://#{host}/wp-admin/setup-config.php?step=1"
      c.http_get
      Chef::Log.info "get2: #{c.body_str}"
      if c.response_code == 200
        Chef::Log.info "Step 1 success!"
        c.url = "http://#{host}/wp-admin/setup-config.php?step=2"
	c.http_post("dbname=#{node[:web_app][:system][:name]}", "uname=#{node[:web_app][:system][:name]}",
		    "pwd=#{node[:web_app][:system][:pass]}", "dbhost=localhost", "prefix=pref_", "submit=Отправить")
	c.perform
	Chef::Log.info "get4: #{c.body_str}"
	c.url = "http://#{host}/wp-admin/install.php?step=2"
	c.http_post("weblog_title=#{node[:web_app][:ui][:title]}", "user_name=#{node[:web_app][:ui][:login]}",
		    "admin_password=#{node[:web_app][:ui][:pass]}", "admin_password2=#{node[:web_app][:ui][:pass]}",
		    "admin_email=#{node[:web_app][:ui][:email]}", "blog_public=1", "Submit=Install WordPress")
	c.perform
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

