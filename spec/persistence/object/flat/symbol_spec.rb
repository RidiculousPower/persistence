
require_relative '../../../../lib/persistence.rb'

describe Symbol do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a symbol object to a persistence port and get it back" do
    class Symbol
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    symbol_object = :symbol
    storage_key   = :symbol_storage_key
    symbol_object.persist!( :explicit_index, storage_key )
    Symbol.persist( :explicit_index, storage_key ).should == symbol_object
    symbol_object.cease!
    Symbol.persist( :explicit_index, storage_key ).should == nil

    symbol_object.persist!
    Symbol.persist( symbol_object.persistence_id ).should == symbol_object
    symbol_object.cease!
    Symbol.persist( symbol_object.persistence_id ).should == nil
  end

end
