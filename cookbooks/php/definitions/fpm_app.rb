
define :fpm_app, :template => "fpm_app.conf.erb", :enable => true do

  application_name = params[:name]

  include_recipe "php"

  template "#{node[:php]['fpm_dir']}/sites-available/#{application_name}.conf" do
    source params[:template]
    owner "root"
    group "root"
    mode 0644
    backup 0
    if params[:cookbook]
      cookbook params[:cookbook]
    end
    variables(
      :application_name => application_name,
      :params => params
    )
    if ::File.exists?("#{node[:php]['fpm_dir']}/sites-enabled/#{application_name}.conf")
      notifies :restart, resources(:service => "#{node[:php][:fpm_service]}"), :immediately
    end
  end

  fpm_site "#{params[:name]}.conf" do
    enable params[:enable]
  end
end
