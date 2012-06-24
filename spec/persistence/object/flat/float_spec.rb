
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
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    float_object  = 42.020
    float_object.persist!
    Float.persist( float_object.persistence_id ).should == float_object
    float_object.cease!
    Float.persist( float_object.persistence_id ).should == nil
  
    storage_key   = 37.0012
    float_object.persist!( :explicit_index, storage_key )
    Float.persist( :explicit_index, storage_key ).should == float_object
    Float.cease!( :explicit_index, storage_key )
    Float.persist( :explicit_index, storage_key ).should == nil
  end
  
end