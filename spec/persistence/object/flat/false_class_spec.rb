
require_relative '../../../../lib/persistence.rb'

describe FalseClass do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a false object to a persistence port and get it back" do
    class FalseClass
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    false_object  = false
    storage_key   = true
    false_object.persist!
    FalseClass.persist( false_object.persistence_id ).should == false_object
    FalseClass.cease!( false_object.persistence_id )
    FalseClass.persist( false_object.persistence_id ).should == nil
  end
  
end