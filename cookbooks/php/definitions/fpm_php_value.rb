define :fpm_php_value  do
  include_recipe "php"

  if params[:value] != ""
    execute "mod php_value #{params[:name]}" do
      command "sed -i 's/#{params[:name]}=(.*)/#{params[:name]}=#{params[:value]}/g' #{node[:php][:ext_conf_dir]}/preset.ini"
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
      only_if do ::File.exists?("#{node[:php][:ext_conf_dir]}/preset.ini") end
    end
    execute "add php_value #{params[:name]}" do
      command "echo '#{params[:name]}=#{params[:value]}' >> #{node[:php][:ext_conf_dir]}/preset.ini"
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
      not_if do ::File.exists?("#{node[:php][:ext_conf_dir]}/preset.ini") end
    end
  end
end

