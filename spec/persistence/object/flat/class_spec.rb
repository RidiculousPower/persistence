
require_relative '../../../../lib/persistence.rb'

describe Class do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a class object to a persistence port and get it back" do
    class Class
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    class_object = Object
    class_object.persist!
    Class.persist( class_object.persistence_id ).should == class_object
    Class.cease!( class_object.persistence_id )
    Class.persist( class_object.persistence_id ).should == nil
  end
  
end