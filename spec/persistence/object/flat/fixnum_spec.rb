
require_relative '../../../../lib/persistence.rb'

describe Fixnum do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a fixnum number object to a persistence port and get it back" do
    class Fixnum
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    fixnum_object = 420
    fixnum_object.persist!
    Fixnum.persist( fixnum_object.persistence_id ).should == fixnum_object
    fixnum_object.cease!
    Fixnum.persist( fixnum_object.persistence_id ).should == nil
  end
  
end