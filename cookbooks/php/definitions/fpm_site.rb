
define :fpm_site, :template => "fpm_app.conf.erb", :enable => true do
  application_name = params[:name]

  include_recipe "php"

  template "#{node[:php]['fpm_dir']}/sites-available/#{application_name}.conf" do
    if params[:template]
      source "#{params[:template]}"
    else
      source "fpm_app.conf.erb"
    end
    owner "root"
    group "root"
    mode 0644
    backup 0
    if params.has_key?("cookbook")
      cookbook "#{params[:cookbook]}"
    else
      cookbook "php"
    end
    variables(
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node[:php]['fpm_dir']}/sites-enabled/#{application_name}.conf")
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
    end
  end
  if params[:enable]
    execute "fpmensite #{params[:name]}" do
      command "/usr/sbin/fpmensite #{params[:name]}.conf"
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
      not_if do
        ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/#{params[:name]}.conf") or
          ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/000-#{params[:name]}.conf")
      end
      only_if do ::File.exists?("#{node[:php][:fpm_dir]}/sites-available/#{params[:name]}.conf") end
    end
  else
    execute "fpmdissite #{params[:name]}" do
      command "/usr/sbin/fpmdissite #{params[:name]}.conf"
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
      only_if do
        ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/#{params[:name]}.conf") or
          ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/000-#{params[:name]}.conf")
      end
    end
  end
end
