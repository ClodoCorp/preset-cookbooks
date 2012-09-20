include_recipe "livestreet"
include_recipe "chef::depends"
include_recipe "hosts"

hosts_host "127.0.0.1" do
  action :create
  host node['web_app']['ui']['domain']
end


ruby_block "setup" do
  block do
    Gem.clear_paths
    require 'curb'

    timeout = 20
    host = "localhost:80"
    real_host = node['web_app']['ui']['domain']
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
      c.url = "http://#{host}/install/?lang=russian"
      c.http_get
      Chef::Log.info "get1: #{c.body_str}"
      c.http_post("install_env_params=1", "install_step_next=дальше")
      c.perform
      sleep(2)
      c.http_post("install_db_params=1", "install_db_server=localhost", "install_db_port=3306",
		  "install_db_name=#{node['web_app']['system']['name']}", "install_db_create=0",
		  "install_db_convert=0", "install_db_convert_from_05=0", "install_db_user=#{node['web_app']['system']['name']}",
		  "install_db_password=#{node['web_app']['system']['pass']}", "install_db_prefix=#{node['web_app']['system']['name']}_",
		  "install_db_engine=InnoDB", "install_step_next=Дальше")
      c.perform
      sleep(2)

      c.http_post("install_admin_params=1", "install_admin_login=#{node['web_app']['ui']['login']}",
		  "install_admin_mail=#{node['web_app']['ui']['email']}", "install_admin_pass=#{node['web_app']['ui']['pass']}",
		  "install_admin_repass=#{node['web_app']['ui']['pass']}", "install_step_next=Дальше")
      c.perform
      sleep(2)
      Chef::Log.info "get2: #{c.body_str}"
      if c.response_code == 200
        Chef::Log.info "Step 1 success!"
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


directory "#{node['web_app']['system']['dir']}/install" do
  action :delete
  recursive true
end

execute "sphinx reindex" do
  command "/usr/bin/indexer --rotate --all > /dev/null 2>&1"
end

