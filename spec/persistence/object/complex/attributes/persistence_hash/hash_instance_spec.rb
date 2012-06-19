
require_relative '../../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance do

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
    
    class Hash
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash
      include ::Persistence::Object::Complex::Attributes::PersistenceHash::HashInstance
    end
    class ComplexObject
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash

      def persist!
        persistence_port.put_object!( self )
        return self
      end

    end
    
    complex_instance = ComplexObject.new
    instance = { }
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
