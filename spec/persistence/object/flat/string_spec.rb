
require_relative '../../../../lib/persistence.rb'

describe String do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a string object to a persistence port and get it back" do
    class String
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    string_object = "some string"
    string_object.persist!
    string_object.persistence_id.should_not == nil
    String.persist( string_object.persistence_id ).should == string_object
    string_object.cease!
    String.persist( string_object.persistence_id ).should == nil
  end
  
end