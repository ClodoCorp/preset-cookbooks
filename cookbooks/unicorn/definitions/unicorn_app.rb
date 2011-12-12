define :unicorn_app, :template => "unicorn_app.conf.erb", :enable => true do

  application_name = params[:name]

  include_recipe "unicorn"

  template "#{node[:unicorn]['dir']}/sites-available/#{application_name}.conf" do
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
    if ::File.exists?("#{node[:unicorn]['dir']}/sites-enabled/#{application_name}.conf")
      notifies :restart, resources(:service => "unicorn-http"), :immediately
    end
  end

  unicorn_site "#{params[:name]}" do
    enable params[:enable]
  end
end
