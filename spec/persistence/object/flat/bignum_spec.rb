
require_relative '../../../../lib/persistence.rb'

describe Bignum do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a bignum number object to a persistence port and get it back" do
    class Bignum
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Flat::ObjectInstance
      extend ::Persistence::Object::Flat::ClassInstance
    end
    bignum_object = 10**20
    bignum_object.persist!
    Bignum.persist( bignum_object.persistence_id ).should == bignum_object
    Bignum.cease!( bignum_object.persistence_id )
    Bignum.persist( bignum_object.persistence_id ).should == nil
  end
  
end