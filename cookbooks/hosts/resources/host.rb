actions :create, :delete

default_action :create

attribute :ip, :kind_of => String, :name_attribute => true
attribute :hosts, :kind_of => Array, :default => []

def initialize(*args)
  super
  @action = :create
end

