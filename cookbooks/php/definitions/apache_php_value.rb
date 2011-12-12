define :apache_php_value  do
  include_recipe "php"
  include_recipe "apache2"

  if params[:value] != ""
    execute "mod php_value #{params[:name]}" do
      command "sed -i 's|#{params[:name]}=(.*)|#{params[:name]}=#{params[:value]}|g' #{node[:php][:ext_conf_dir]}/preset.ini"
      notifies :reload, resources(:service => "apache2"), :immediately
      only_if do ::File.exists?("#{node[:php][:ext_conf_dir]}/preset.ini") end
    end
    execute "add php_value #{params[:name]}" do
      command "echo '#{params[:name]}=#{params[:value]}' >> #{node[:php][:ext_conf_dir]}/preset.ini"
      notifies :reload, resources(:service => "apache2"), :immediately
      not_if do ::File.exists?("#{node[:php][:ext_conf_dir]}/preset.ini") end
    end
  end
end

