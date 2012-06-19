
require_relative '../../../../lib/persistence.rb'

describe Float do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a float number object to a persistence port and get it back" do
    class Float
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    float_object  = 42.020
    float_object.persist!
    Float.persist( float_object.persistence_id ).should == float_object
    Float.cease!( float_object.persistence_id )
    Float.persist( float_object.persistence_id ).should == nil
  end
  
end