action :create do
    validate_resource_attributes!
    create
    new_resource.updated_by_last_action(true)
end


def create
  execute "add ip #{new_resource.ip}" do
    command "echo '#{new_resource.ip} #{new_resource.hosts.join(" ")}' >> /etc/hosts"
  end
end

def validate_resource_attributes!
 if ( new_resource.ip.nil? || new_resource.ip.empty? )
    raise "name attribute is required"
 end

 if ( new_resource.hosts.nil? || new_resource.hosts.empty? )
    raise "host attribute is required"
 end
end


