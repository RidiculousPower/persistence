
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Array do

  before :all do
    ::Persistence.enable_port( :mock, ::Persistence::Adapter::Mock.new )
  end

  after :all do
    ::Persistence.disable_port( :mock )
  end

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  it "can create a persistence hash to correspond to persistence state" do

    class ::Persistence::Object::Complex::Array::SubArray < Array
      include ::Persistence::Object::Complex
      include ::Persistence::Object::Complex::Array::ObjectInstance
      extend ::Persistence::Object::Complex::Array::ClassInstance
    end
    class ::Persistence::Object::Complex::Array::ComplexObject

      include ::Persistence::Object::Complex
      
      def persist!        
        persistence_port.put_object!( self )
        return self
      end

    end

    complex_instance = ::Persistence::Object::Complex::Array::ComplexObject.new
    instance = ::Persistence::Object::Complex::Array::SubArray.new( [ 1, 2, 3, 4, 5, complex_instance ] )
    
    instance.persistence_hash_to_port.should == { 0 => 1,
                                                  1 => 2,
                                                  2 => 3,
                                                  3 => 4,
                                                  4 => 5,
                                                  5 => complex_instance.persistence_id.to_s }
    
    instance[ 5 ].should == complex_instance
    instance.instance_eval { is_complex_object?( self [ 5 ] ) }.should == true
    
  end
  
end
