
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
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    false_object  = false
    storage_key   = true
    false_object.persist!
    FalseClass.persist( false_object.persistence_id ).should == false_object
    false_object.cease!
    FalseClass.persist( false_object.persistence_id ).should == nil

    false_object  = false
    storage_key   = true
    false_object.persist!( :explicit_index, storage_key )
    FalseClass.persist( :explicit_index, storage_key ).should == false_object
    FalseClass.cease!( :explicit_index, storage_key )
    FalseClass.persist( :explicit_index, storage_key ).should == nil
  end
  
end