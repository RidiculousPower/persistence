
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
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end

    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    complex_object.persist!
    Complex.persist( complex_object.persistence_id ).should == complex_object
    complex_object.cease!
    Complex.persist( complex_object.persistence_id ).should == nil

    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    complex_object.persist!( :explicit_index, storage_key )
    Complex.persist( :explicit_index, storage_key ).should == complex_object
    Complex.cease!( :explicit_index, storage_key )
    Complex.persist( :explicit_index, storage_key ).should == nil

  end
  
end