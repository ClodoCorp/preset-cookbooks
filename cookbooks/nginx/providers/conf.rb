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
  if ( new_resource.source.nil? || new_resource.source.empty? )
    raise "source attribute is required"
  end
  template "#{node['nginx']['dir']}/conf.d/#{new_resource.name}.conf" do
    source new_resource.source
    owner "root"
    group "root"
    mode 0644
    if new_resource.cookbook
      cookbook new_resource.cookbook
    end
    variables(new_resource.variables)
    notifies :reload, resources(:service => "nginx"), :immediately
  end
end

def validate_resource_attributes!
 if ( new_resource.name.nil? || new_resource.name.empty? )
    raise "name attribute is required"
 end
end

