require_relative '../../../../lib/rpersistence.rb'

Rpersistence.enable_port( :mock, Rpersistence::Adapter::Mock.new( 'no home required' ) )

describe Rpersistence::ObjectInstance::Persistence do

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  it "can create a persistence hash to correspond to persistence state" do

    class Mock01
      attr_atomic           :flat_atomic_attribute,             :@flat_atomic_variable
      attr_atomic           :complex_atomic_attribute,          :@complex_atomic_variable
      attr_non_atomic       :flat_non_atomic_attribute,         :@flat_non_atomic_variable
      attr_non_atomic       :complex_non_atomic_attribute,      :@complex_non_atomic_variable
      attr_non_persistent   :flat_non_persistent_attribute,     :@flat_non_persistent_variable
      attr_non_persistent   :complex_non_persistent_attribute,  :@complex_non_persistent_variable
      attr_flat             :flat_attribute,                    :@flat_variable
      attr_accessor         :flat_atomic_attribute, :complex_atomic_attribute, :flat_non_atomic_attribute, :complex_non_atomic_attribute, 
                            :flat_non_persistent_attribute, :complex_non_persistent_attribute, :flat_attribute
    end
    
    instance = Mock01.new

    # flat object for attribute and for variable
    instance.flat_atomic_attribute = 'flat atomic_attribute value'
    instance.instance_variable_set( :@flat_atomic_variable, '@flat_atomic_variable value' )
    complex_atomic_element = Mock01.new
    complex_atomic_element.flat_atomic_attribute = 'flat sub-atomic attribute'
    instance.complex_atomic_attribute = complex_atomic_element
    instance.instance_variable_set( :@complex_atomic_variable, complex_atomic_element )

    # complex object for attribute and for variable
    instance.flat_non_atomic_attribute = 'flat non_atomic_attribute value'
    instance.instance_variable_set( :@flat_non_atomic_variable, '@flat_non_atomic_variable value' )
    complex_non_atomic_element = Mock01.new
    complex_non_atomic_element.flat_atomic_attribute = 'flat sub-atomic attribute'
    instance.complex_non_atomic_attribute = complex_non_atomic_element
    instance.instance_variable_set( :@complex_non_atomic_variable, complex_non_atomic_element )
    
    # non-persistent value
    instance.flat_non_persistent_attribute = 'flat_non_persistent_attribute value'
    instance.instance_variable_set( :@flat_non_persistent_variable, '@flat_non_persistent_variable value' )
    instance.complex_non_persistent_attribute = 'complex_non_persistent_attribute value'
    instance.instance_variable_set( :@complex_non_persistent_variable, '@complex_non_persistent_variable value' )
    
    # flat complex object for attribute and for variable
    instance.flat_attribute = 'flat_attribute value'
    instance.instance_variable_set( :@flat_variable, '@flat_variable value' )
    
    # get hash
    hash_to_port = instance.persistence_hash_to_port
    
    # make sure that flat atomic elements and non-atomic elements are included
    hash_to_port[ :@flat_atomic_attribute ].should == 'flat atomic_attribute value'
    hash_to_port[ :@flat_atomic_variable ].should == '@flat_atomic_variable value'    
    hash_to_port[ :@flat_non_atomic_attribute ].should == 'flat non_atomic_attribute value'
    hash_to_port[ :@flat_non_atomic_variable ].should == '@flat_non_atomic_variable value'
    
    # make sure that non-persistent elements are not included
    hash_to_port.has_key?( :@complex_non_persistent_attribute ).should_not == true
    hash_to_port.has_key?( :@complex_non_persistent_variable ).should_not == true
    
    # make sure that complex objects are stored by ID
    hash_to_port[ :@complex_atomic_attribute ].should == complex_atomic_element.persistence_id
    hash_to_port[ :@complex_atomic_variable ].should == complex_atomic_element.persistence_id
    hash_to_port[ :@complex_non_atomic_attribute ].should == complex_non_atomic_element.persistence_id
    hash_to_port[ :@complex_non_atomic_variable ].should == complex_non_atomic_element.persistence_id
        
  end
  
end

