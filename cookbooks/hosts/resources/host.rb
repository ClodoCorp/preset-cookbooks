actions :create, :delete

attribute :name, :kind_of => String
attribute :host, :kind_of => String

def initialize(*args)
  super
  @action = :create
end

