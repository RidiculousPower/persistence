
require_relative '../../../../lib/persistence.rb'

describe Bignum do
  
  before :each do

    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )

    class Bignum
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    @bignum_object = 10**20
  end
  
  after :each do
    ::Persistence.disable_port( :mock )
  end

  context "#persist!" do
    it "should persist without error" do
      @bignum_object.persist!
    end    
  end

  context "#persist" do
    it "should return the bignum" do
      @bignum_object.persist!
      Bignum.persist( @bignum_object.persistence_id ).should == @bignum_object
    end
  end
  
  context "#cease!" do
    it "should delete the bignum" do
      @bignum_object.persist!
      @bignum_object.cease!
      Bignum.persist( @bignum_object.persistence_id ).should == nil
    end
  end

  context "with index" do
    it "should persist! and persist" do
      #can put a bignum number object to a persistence port and get it back via an indexed value
      storage_key   = 10**40
      @bignum_object.persist!( :explicit_index => storage_key )
      Bignum.persist( :explicit_index => storage_key ).should == @bignum_object
    end
    it "should cease!" do
      storage_key   = 10**40
      @bignum_object.persist!( :explicit_index => storage_key )
      Bignum.cease!( :explicit_index => storage_key )
      Bignum.persist( :explicit_index => storage_key ).should == nil
    end
  end
  
end
