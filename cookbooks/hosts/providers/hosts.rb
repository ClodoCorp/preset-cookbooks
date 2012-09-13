def load_current_resource
    @host = Chef::Resource::WebApplication.new(new_resource.name)
    @host.name(new_resource.name)
    @host.host(new_resource.host)
    nil
end


action :add do
    validate_resource_attributes!
    add
    new_resource.updated_by_last_action(true)
end


def add
  execute "add ip #{@host.name}" do
    command "echo '#{@host.name} #{@host.host}' >> /etc/hosts"
  end
end

def validate_resource_attributes!
 if ( @host.name.nil? || @host.name.empty? )
    raise "name attribute is required"
 end

 if ( @host.host.nil? || @host.host.empty? )
    raise "host attribute is required"
 end
end


