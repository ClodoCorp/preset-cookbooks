require 'uri'

action :create do
    validate_resource_attributes!
    create
    new_resource.updated_by_last_action(true)
end

def create
  file = uri.parse(new_resource.source).path.split("/").last

  remote_file "mirror #{new_resource.name}" do
    path new_resource.path
    source "http://pkgs.clodo.ru/presets/#{file}"
    mode new_resource.mode
    action :nothing
  end

  remote_file "origin #{new_resource.name}" do
    path new_resource.path
    source new_resource.source
    mode new_resource.mode
    action :nothing
  end

  ruby_block "check" do
    block do
      begin
        n = Net::HTTP.new("pkgs.clodo.ru", "80")
        n.request_head("/presets/#{new_resource.name}").value
	notifies :create, resources(:remote_file => "mirror #{new_resource.name}"), :immediately
      rescue Net::HTTPServerException
        notifies :create, resources(:remote_file => "origin #{new_resource.name}"), :immediately
      end
      action :create
    end
  end
end

def validate_resource_attributes!
 if ( new_resource.source.nil? || new_resource.source.empty? )
    raise "source attribute is required"
 end

 if ( new_resource.name.nil? || new_resource.name.empty? )
    raise "name attribute is required"
 end
end


