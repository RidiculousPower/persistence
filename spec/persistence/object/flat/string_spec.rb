
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a string object to a persistence port and get it back" do
    class ::Persistence::Object::Flat::StringMock < String
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    string_object = ::Persistence::Object::Flat::StringMock.new( "some string" )
    string_object.persist!
    string_object.persistence_id.should_not == nil
    ::Persistence::Object::Flat::StringMock.persist( string_object.persistence_id ).should == string_object
    string_object.cease!
    ::Persistence::Object::Flat::StringMock.persist( string_object.persistence_id ).should == nil
  
    string_object = Persistence::Object::Flat::StringMock.new( "some string" )
    storage_key   = "string storage key"
    string_object.persist!( :explicit_index, storage_key )
    Persistence::Object::Flat::StringMock.persist( :explicit_index, storage_key ).should == string_object
    Persistence::Object::Flat::StringMock.cease!( :explicit_index, storage_key )
    Persistence::Object::Flat::StringMock.persist( :explicit_index, storage_key ).should == nil
  end
  
end