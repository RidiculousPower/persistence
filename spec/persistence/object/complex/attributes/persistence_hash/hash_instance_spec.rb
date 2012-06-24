
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Hash do

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
    module ::Persistence::Object::Complex::Hash::PersistenceHashToPortMock 
    
      class HashMock < Hash
        include ::Persistence::Object::Complex
        include ::Persistence::Object::Complex::Hash::ObjectInstance
        extend ::Persistence::Object::Complex::Hash::ClassInstance
      end
      
      class ComplexObject

        include ::Persistence::Object::Complex

        def persist!
          persistence_port.put_object!( self )
          return self
        end

      end
    
      complex_instance = ComplexObject.new
      instance = HashMock.new
      instance[ 1 ] = :some_value
      instance[ :key ] = :other_value
      instance[ complex_instance ] = :complex_value
      instance[ :complex_key ] = complex_instance
    
      instance.persistence_hash_to_port.should == { 1 => :some_value,
                                                    :key => :other_value,
                                                    complex_instance.persistence_id.to_s => :complex_value,
                                                    :complex_key => complex_instance.persistence_id.to_s }
    
      instance[ :complex_key ].should == complex_instance
      instance[ complex_instance ].should == :complex_value

    end
  end

end
