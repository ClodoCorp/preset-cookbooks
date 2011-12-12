define :unicorn_site, :enable => true do
  include_recipe "unicorn"
  include_recipe "nginx"

  if params[:enable]
    execute "ucensite #{params[:name]}" do
      command "/usr/sbin/ucensite #{params[:name]}"
      notifies :restart, resources(:service => "unicorn-http"), :immediately
      not_if do
        ::File.symlink?("#{node[:unicorn][:dir]}/sites-enabled/#{params[:name]}") or
          ::File.symlink?("#{node[:unicorn][:dir]}/sites-enabled/000-#{params[:name]}")
      end
      only_if do ::File.exists?("#{node[:unicorn][:dir]}/sites-available/#{params[:name]}") end
    end
    nginx_site "#{params[:name]}" do
      action "create"
      enable true
    end
  else
    execute "ucdissite #{params[:name]}" do
      command "/usr/sbin/ucdissite #{params[:name]}"
      notifies :restart, resources(:service => "unicorn-http"), :immediately
      only_if do
        ::File.symlink?("#{node[:unicorn][:dir]}/sites-enabled/#{params[:name]}") or
          ::File.symlink?("#{node[:unicorn][:dir]}/sites-enabled/000-#{params[:name]}")
      end
    end
    nginx_site "#{params[:name]}" do
      enable false
    end
  end
end

