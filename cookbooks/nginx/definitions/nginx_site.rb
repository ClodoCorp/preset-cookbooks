
define :nginx_site, :enable => true, :action => "", :vars => [] do

  if params[:action] == "create"
    template "#{node[:nginx][:dir]}/sites-available/#{params[:name]}" do
      if params[:source]
        source "#{params[:source]}"
      else
	source "default.conf.erb"
      end
      if params.has_key?("cookbook")
        cookbook "#{params[:cookbook]}"
      end
      if params[:vars].is_a?(Hash)
        variables ( params[:vars] )
      end
      mode 0644
      owner "root"
      group "root"
    end
  end

  if params[:enable]
    execute "nxensite #{params[:name]}" do
      command "/usr/sbin/nxensite #{params[:name]}"
      notifies :reload, resources(:service => "nginx")
      not_if do ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") end
    end
  end

  if params[:disable]
    execute "nxdissite #{params[:name]}" do
      command "/usr/sbin/nxdissite #{params[:name]}"
      notifies :reload, resources(:service => "nginx"), :immediately
      only_if do ::File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") end
    end
  end

end
