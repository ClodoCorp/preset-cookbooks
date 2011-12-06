
define :fpm_site, :enable => true do
  include_recipe "php"
  include_recipe "nginx"
  
  if params[:enable]
    execute "fpmensite #{params[:name]}" do
      command "/usr/sbin/fpmensite #{params[:name]}"
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
      not_if do
        ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/#{params[:name]}") or
          ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/000-#{params[:name]}")
      end
      only_if do ::File.exists?("#{node[:php][:fpm_dir]}/sites-available/#{params[:name]}") end
    end
    nginx_site "#{params[:name]}" do
      action "create"
      enable true
    end
  else
    execute "fpmdissite #{params[:name]}" do
      command "/usr/sbin/fpmdissite #{params[:name]}"
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
      only_if do
        ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/#{params[:name]}") or
          ::File.symlink?("#{node[:php][:fpm_dir]}/sites-enabled/000-#{params[:name]}")
      end
    end
    nginx_site "#{params[:name]}" do
      enable false
    end
  end
end

