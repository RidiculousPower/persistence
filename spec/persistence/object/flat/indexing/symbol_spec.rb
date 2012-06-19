
require_relative '../../../../../lib/persistence.rb'

describe Symbol do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a symbol object to a persistence port and get it back" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class Symbol
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
    symbol_object = :symbol
    storage_key   = :symbol_storage_key
    symbol_object.persist!( :explicit_index, storage_key )
    Symbol.persist( :explicit_index, storage_key ).should == symbol_object
    Symbol.cease!( :explicit_index, storage_key )
    Symbol.persist( :explicit_index, storage_key ).should == nil
  end

end