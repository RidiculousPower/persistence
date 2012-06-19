
if $__persistence__spec__development__
  require_relative '../lib/persistence-object-flat.rb'
  require_relative '../../../adapters/mock/lib/persistence-adapter-mock.rb'
  require_relative '../../../port/lib/persistence-port.rb'
else
  require 'persistence-object-flat'
  require 'persistence-port'
  require 'persistence-adapter-mock'
end

describe TrueClass do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a true object to a persistence port and get it back" do
    class TrueClass
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    true_object = true
    true_object.persist!
    TrueClass.persist( true_object.persistence_id ).should == true_object
    TrueClass.cease!( true_object.persistence_id )
    TrueClass.persist( true_object.persistence_id ).should == nil
  end
  
end