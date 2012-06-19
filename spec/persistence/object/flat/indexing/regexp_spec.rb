
require_relative '../../../../../lib/persistence.rb'

describe Regexp do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a regexp object to a persistence port and get it back" do
    class ::Persistence::Port::Bucket
      include ::Persistence::Port::Indexing::Bucket
    end
    class Regexp
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
    regexp_object = /some_regexp_([A-Za-z])/
    storage_key   = /regexp_storage_key/
    regexp_object.persist!( :explicit_index, storage_key )
    Regexp.persist( :explicit_index, storage_key ).should == regexp_object
    Regexp.cease!( :explicit_index, storage_key )
    Regexp.persist( :explicit_index, storage_key ).should == nil
  end
  
end