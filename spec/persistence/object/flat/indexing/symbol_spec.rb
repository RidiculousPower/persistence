
require_relative '../../../../../lib/persistence.rb'

describe Symbol do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a symbol object to a persistence port and get it back" do
    class Symbol
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    symbol_object = :symbol
    symbol_object.persist!
    Symbol.persist( symbol_object.persistence_id ).should == symbol_object
    symbol_object.cease!
    Symbol.persist( symbol_object.persistence_id ).should == nil
  end

end
