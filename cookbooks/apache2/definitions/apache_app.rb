
define :apache_app, :template => "apache_app.conf.erb", :enable => true do
  
  application_name = params[:name]

  include_recipe "apache2"
  include_recipe "apache2::mod_rewrite"
  include_recipe "apache2::mod_deflate"
  include_recipe "apache2::mod_headers"
  
  template "#{node[:apache][:dir]}/sites-available/#{application_name}.conf" do
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
#    if ::File.exists?("#{node[:apache][:dir]}/sites-enabled/#{application_name}.conf")
#      notifies :restart, resources(:service => "apache2"), :immediately
#    end
  end
  
  apache_site "#{params[:name]}.conf" do
    enable params[:enable]
  end
end
