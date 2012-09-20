actions :create

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :path, :kind_of => String
attribute :source, :kind_of => String
attribute :mode, :kind_of => String

def initialize(*args)
  super
  @action = :create
end

