
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
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    regexp_object = ::Persistence::Object::Flat::RegexpMock.new( /some_regexp_([A-Za-z])/ )
    regexp_object.persist!
    ::Persistence::Object::Flat::RegexpMock.persist( regexp_object.persistence_id ).should == regexp_object
    regexp_object.cease!
    ::Persistence::Object::Flat::RegexpMock.persist( regexp_object.persistence_id ).should == nil
  end
  
end