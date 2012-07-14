
require_relative '../../../../lib/persistence.rb'

describe Bignum do
  
  before :all do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class Bignum
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end

  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a bignum number object to a persistence port and get it back" do
    
    bignum_object = 10**20
    bignum_object.persist!
    Bignum.persist( bignum_object.persistence_id ).should == bignum_object
    bignum_object.cease!
    Bignum.persist( bignum_object.persistence_id ).should == nil

  end

  it "can put a bignum number object to a persistence port and get it back via an indexed value" do
    bignum_object = 10**20
    storage_key   = 10**40
    bignum_object.persist!( :explicit_index => storage_key )
    Bignum.persist( :explicit_index => storage_key ).should == bignum_object
    Bignum.cease!( :explicit_index => storage_key )
    Bignum.persist( :explicit_index => storage_key ).should == nil

  end
  
end
