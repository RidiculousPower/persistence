
require_relative '../../../../lib/persistence.rb'

describe Rational do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a rational number object to a persistence port and get it back" do
    class Rational
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    rational_object = Rational( 42, 37 )
    rational_object.persist!
    Rational.persist( rational_object.persistence_id ).should == rational_object
    Rational.cease!( rational_object.persistence_id )
    Rational.persist( rational_object.persistence_id ).should == nil
  end
  
end