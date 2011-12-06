define :mysql_db, :name => "" do
  include_recipe "mysql"

  if params[:name] != ""
    if params[:action] == "create"
      execute "/usr/bin/mysqladmin create #{params[:name]}" do
        command "/usr/bin/mysqladmin -uroot -p#{node['mysql']['server_root_password']} create #{params[:name]}"
        action :run
        not_if "/usr/bin/mysql -uroot -p#{node['mysql']['server_root_password']} -e 'show databases;' | grep -q #{params[:name]}"
      end
    end
    if params[:action] == "delete"
      execute "/usr/bin/mysqladmin drop #{params[:name]}" do
        command "/usr/bin/mysqladmin -uroot -p#{node['mysql']['server_root_password']} --force drop #{params[:name]}"
      end
    end
  end
end

