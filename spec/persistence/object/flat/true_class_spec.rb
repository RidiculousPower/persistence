
require_relative '../../../../lib/persistence.rb'

describe TrueClass do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a true object to a persistence port and get it back" do
    class TrueClass
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    true_object = true
    true_object.persist!
    TrueClass.persist( true_object.persistence_id ).should == true_object
    true_object.cease!
    TrueClass.persist( true_object.persistence_id ).should == nil

    storage_key = false
    true_object.persist!( :explicit_index, storage_key )
    TrueClass.persist( :explicit_index, storage_key ).should == true_object
    true_object.cease!
    TrueClass.persist( :explicit_index, storage_key ).should == nil
  end
  
end