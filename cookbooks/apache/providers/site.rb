action :create do
  validate_resource_attributes!
  create
  new_resource.updated_by_last_action(true)
end

action :enable do
  validate_resource_attributes!
  enable
  new_resource.updated_by_last_action(true)  
end

action :disable do
  validate_resource_attributes!
  disable
  new_resource.updated_by_last_action(true)
end

private

def create
  template "#{node['apache']['dir']}/sites-available/#{new_resource.name}" do
    source new_resource.source
    owner "root"
    group node['apache']['root_group']
    mode "0644"
    if new_resource.cookbook
      cookbook new_resource.cookbook
    end
    variables(new_resource.variables)
    if ::File.exists?("#{node['apache']['dir']}/sites-enabled/#{new_resource.name}")
      notifies :reload, resources(:service => "apache2"), :immediately
    end
  end
end

def enable 
  execute "a2ensite #{new_resource.name}" do
    command "/usr/sbin/a2ensite #{new_resource.name}"
    notifies :reload, resources(:service => "apache2"), :immediately
    not_if do
      ::File.symlink?("#{node['apache']['dir']}/sites-enabled/#{new_resource.name}") or
      ::File.symlink?("#{node['apache']['dir']}/sites-enabled/000-#{new_resource.name}")
    end
    only_if do
      ::File.exists?("#{node['apache']['dir']}/sites-available/#{new_resource.name}")
    end
  end
end

def disable 
  execute "a2dissite #{new_resource.name}" do
    command "/usr/sbin/a2dissite #{new_resource.name}"
    notifies :reload, resources(:service => "apache2"), :immediately
    only_if do
      ::File.symlink?("#{node['apache']['dir']}/sites-enabled/#{new_resource.name}") or
      ::File.symlink?("#{node['apache']['dir']}/sites-enabled/000-#{new_resource.name}")
    end
  end
end

def validate_resource_attributes!
 if ( new_resource.name.nil? || new_resource.name.empty? )
    raise "name attribute is required"
 end
end


