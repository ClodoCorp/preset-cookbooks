
define :mysql_grants do
  include_recipe "mysql"

  template "/tmp/#{params[:name]}.sql" do
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode 0600
    backup 0
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :user     => node['web_app']['system']['name'],
      :password => node['web_app']['system']['pass'],
      :database => node['web_app']['system']['name']
    )
  end

  execute "mysql-install-wp-privileges" do
    command "/usr/bin/mysql -u root -p#{node['web_app']['system']['pass']} < /tmp/#{params[:name]}.sql"
  end

  file "/tmp/#{params[:name]}.sql" do
    action :delete
    backup 0
  end
end

