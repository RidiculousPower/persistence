
require_relative '../../../../../lib/persistence.rb'

describe ::Persistence::Object::Complex::Attributes::PersistenceHash do

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

    class ::Persistence::Object::Complex::Attributes::PersistenceHash::Mock
      
      include ::Persistence::Port::ObjectInstance
      extend ::Persistence::Port::ClassInstance
      include ::Persistence::Object::ObjectInstance
      extend ::Persistence::Object::ClassInstance
      include ::Persistence::Object::Complex::Attributes
      extend ::Persistence::Object::Complex::Attributes
      include ::Persistence::Object::Complex::Attributes::Flat
      extend ::Persistence::Object::Complex::Attributes::Flat
      include ::Persistence::Object::Complex::Attributes::PersistenceHash

      attr_atomic_accessor           :flat_atomic_attribute
      attr_atomic_accessor           :complex_atomic_attribute
      attr_non_atomic_accessor       :flat_non_atomic_attribute
      attr_non_atomic_accessor       :complex_non_atomic_attribute
      attr_accessor                  :flat_non_persistent_attribute
      attr_accessor                  :complex_non_persistent_attribute
      attr_flat                      :flat_attribute
      attr_accessor                  :flat_non_persistent_attribute, :complex_non_persistent_attribute, :flat_attribute
            
      def persist!
        persistence_port.put_object!( self )
        return self
      end
      
    end
    
    instance = ::Persistence::Object::Complex::Attributes::PersistenceHash::Mock.new

    # flat object for attribute and for variable
    instance.flat_atomic_attribute = 'flat atomic_attribute value'
    complex_atomic_element = ::Persistence::Object::Complex::Attributes::PersistenceHash::Mock.new
    complex_atomic_element.flat_atomic_attribute = 'flat sub-atomic attribute'
    instance.complex_atomic_attribute = complex_atomic_element

    # complex object for attribute and for variable
    instance.flat_non_atomic_attribute = 'flat non_atomic_attribute value'
    complex_non_atomic_element = ::Persistence::Object::Complex::Attributes::PersistenceHash::Mock.new
    complex_non_atomic_element.flat_atomic_attribute = 'flat sub-atomic attribute'
    instance.complex_non_atomic_attribute = complex_non_atomic_element
    
    # non-persistent value
    instance.flat_non_persistent_attribute = 'flat_non_persistent_attribute value'
    instance.complex_non_persistent_attribute = 'complex_non_persistent_attribute value'
    
    # flat complex object for attribute and for variable
    instance.flat_attribute = 'flat_attribute value'
    
    # get hash
    hash_to_port = instance.persistence_hash_to_port

    # make sure that flat atomic elements and non-atomic elements are included
    hash_to_port[ :flat_atomic_attribute ].should == 'flat atomic_attribute value'
    hash_to_port[ :flat_non_atomic_attribute ].should == 'flat non_atomic_attribute value'
    
    # make sure that complex objects are stored by ID
    hash_to_port[ :complex_atomic_attribute ].persistence_id.should == complex_atomic_element.persistence_id
    hash_to_port[ :complex_non_atomic_attribute ].persistence_id.should == complex_non_atomic_element.persistence_id
    
  end
  
end

