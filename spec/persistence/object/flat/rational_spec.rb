
require_relative '../../../../lib/persistence.rb'

describe Rational do
  
  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end
  
  after :all do
    ::Persistence.disable_port( :mock )
  end

  it "can put a rational number object to a persistence port and get it back" do
    class Rational
      include ::Persistence::Object::Flat
      explicit_index :explicit_index
    end
    rational_object = Rational( 42, 37 )
    rational_object.persist!
    Rational.persist( rational_object.persistence_id ).should == rational_object
    rational_object.cease!
    Rational.persist( rational_object.persistence_id ).should == nil

    rational_object = Rational( 42, 37 )
    storage_key     = Rational( 42, 420 )
    rational_object.persist!( :explicit_index, storage_key )
    Rational.persist( :explicit_index, storage_key ).should == rational_object
    Rational.cease!( :explicit_index, storage_key )
    Rational.persist( :explicit_index, storage_key ).should == nil
  end
  
end