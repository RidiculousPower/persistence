
require_relative '../../../../lib/persistence.rb'

describe ::Persistence::Object::Flat do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a regexp object to a persistence port and get it back" do
    class ::Persistence::Object::Flat::RegexpMock < Regexp
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    regexp_object = ::Persistence::Object::Flat::RegexpMock.new( /some_regexp_([A-Za-z])/ )
    regexp_object.persist!
    ::Persistence::Object::Flat::RegexpMock.persist( regexp_object.persistence_id ).should == regexp_object
    regexp_object.cease!
    ::Persistence::Object::Flat::RegexpMock.persist( regexp_object.persistence_id ).should == nil

    storage_key   = /regexp_storage_key/
    regexp_object.persist!( :explicit_index, storage_key )
    ::Persistence::Object::Flat::RegexpMock.persist( :explicit_index, storage_key ).should == regexp_object
    ::Persistence::Object::Flat::RegexpMock.cease!( :explicit_index, storage_key )
    ::Persistence::Object::Flat::RegexpMock.persist( :explicit_index, storage_key ).should == nil
  end
  
end