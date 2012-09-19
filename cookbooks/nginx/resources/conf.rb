actions :create, :delete, :enable, :disable

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :source, :kind_of => String, :default => nil
attribute :cookbook, :kind_of => String, :default => nil
attribute :variables, :kind_of => Hash

def initialize(*args)
  super
  @action = :create
end

