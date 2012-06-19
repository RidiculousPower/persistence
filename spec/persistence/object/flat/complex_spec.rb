
require_relative '../../../../lib/persistence.rb'

describe Complex do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a complex number object to a persistence port and get it back" do
    class Complex
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    complex_object.persist!
    Complex.persist( complex_object.persistence_id ).should == complex_object
    Complex.cease!( complex_object.persistence_id )
    Complex.persist( complex_object.persistence_id ).should == nil
  end
  
end