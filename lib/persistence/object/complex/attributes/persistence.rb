
module ::Persistence::Object::Complex::Attributes::Persistence

  ###################
  #  get_attribute  #
  ###################

  def get_attribute( attribute )
    
    value = nil

    variable_name = attribute.variable_name

    # if we're atomic and have an ID, get from persistence port (call accessor read method)
    if persistence_id and atomic_attribute_reader?( attribute )

      # the first time we load the attribute we load the object corresponding to the ID
      # once our object has been loaded we don't need to get it again
      # so we can check to see if the object-local variable is already set to a value, 
      # in which case we do not load it from the persistence port    
      if instance_variable_defined?( variable_name )
        
        value = instance_variable_get( variable_name )

      else
        
        value = persistence_bucket.get_attribute( self, attribute )

        if value.is_a?( ::Persistence::Object::Complex::ComplexObject )

          value.persistence_port = persistence_port

          value = value.persist

          # we only want to store atomic attributes that are complex objects
          instance_variable_set( variable_name, value )

        end

      end

    # otherwise get from object (not yet persisted)
    else

      value = instance_variable_get( variable_name )

    end

    return value
    
  end

  ###################
  #  set_attribute  #
  ###################

  def set_attribute( attribute, value )
    
    variable_name = attribute.variable_name
    
    # if we're atomic and have an ID, put to persistence port
    if persistence_id and atomic_attribute?( attribute )

      value = persist_as_sub_object_or_attribute_and_return_id_or_value( value )

      persistence_bucket.put_attribute!( self, attribute, value )

    # otherwise get from object
    else

      instance_variable_set( variable_name, value )

    end

    return value
    
  end

  ##############
  #  persist!  #
  ##############

  def persist!
    
    this_call_generates_id = ( persistence_id ? false : true )

    super
    
    if this_call_generates_id
      remove_atomic_attribute_values
    end    

    return self
    
  end

  #######################
  #  load_atomic_state  #
  #######################
  
  def load_atomic_state
    
    atomic_attribute_readers.each do |this_attribute|
      instance_variable_set( this_attribute.variable_name, __send__( this_attribute ) )
    end
    
    return self
    
  end

  ###############################################################
  #  persist_as_sub_object_or_attribute_and_return_id_or_value  #
  ###############################################################
 
  def persist_as_sub_object_or_attribute_and_return_id_or_value( value )
  
    if is_complex_object?( value ) and ! persists_flat?( value )

      value.persist!

      sub_id_or_attribute_value = ::Persistence::Object::Complex::ComplexObject.new( value )

    else

      sub_id_or_attribute_value = value

    end
  
    return sub_id_or_attribute_value
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ####################################
  #  remove_atomic_attribute_values  #
  ####################################
  
  def remove_atomic_attribute_values
    
    encapsulation = ::CascadingConfiguration::Core::Encapsulation.encapsulation( :default )
    
    atomic_attribute_readers.each do |this_atomic_accessor|
      
      if encapsulation.has_configuration_value?( self, this_atomic_accessor ) and
        ! is_complex_object?( encapsulation.get_configuration_variable( self, this_atomic_accessor ) )

        encapsulation.remove_configuration_variable( self, this_atomic_accessor )

      end

    end
    
  end

  ########################
  #  is_complex_object?  #
  ########################
  
  def is_complex_object?( object )
    
    is_complex = true

    if  object.is_a?( Bignum )                                  or
        object.is_a?( Fixnum )                                  or
        object.is_a?( Complex )                                 or
        object.is_a?( Rational )                                or
        object.is_a?( TrueClass )                               or
        object.is_a?( FalseClass )                              or
        object.is_a?( String )                                  or
        object.is_a?( Symbol )                                  or
        object.is_a?( Regexp )                                  or
        object.is_a?( File )                                    or
        object.is_a?( ::Persistence::Object::Flat::File::Contents )   or
        object.is_a?( ::Persistence::Object::Flat::File::Path )       or
        object.is_a?( NilClass )
      
      is_complex = false

    end

    return is_complex
    
  end  

end
