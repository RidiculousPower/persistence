
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
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    fixnum_object = 420
    fixnum_object.persist!
    Fixnum.persist( fixnum_object.persistence_id ).should == fixnum_object
    fixnum_object.cease!
    Fixnum.persist( fixnum_object.persistence_id ).should == nil

    storage_key   = 12
    fixnum_object.persist!( :explicit_index, storage_key )
    Fixnum.persist( :explicit_index, storage_key ).should == fixnum_object
    Fixnum.cease!( :explicit_index, storage_key )
    Fixnum.persist( :explicit_index, storage_key ).should == nil
  end
  
end