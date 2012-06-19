
require_relative '../../../../../lib/persistence.rb'

describe Complex do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a complex number object to a persistence port and get it back" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class Complex
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Indexing::ClassInstance
      include ::Persistence::Object::Indexing::ObjectInstance
      extend ::Persistence::Object::Flat::Indexing::ClassInstance
      include ::Persistence::Object::Flat::Indexing::ObjectInstance
      explicit_index :explicit_index
    end
    complex_object  = Complex( 42, 1 )
    storage_key     = Complex( 37, 12 )
    complex_object.persist!( :explicit_index, storage_key )
    Complex.persist( :explicit_index, storage_key ).should == complex_object
    Complex.cease!( :explicit_index, storage_key )
    Complex.persist( :explicit_index, storage_key ).should == nil
  end
  
end