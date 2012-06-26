
###
# Methods applied to object instances of complex objects enabled with persistence capabilities.
#
module ::Persistence::Object::Complex::ObjectInstance

  include ::Persistence::Object::Complex::Attributes

  include ::Persistence::Object::Complex::ClassAndObjectInstance

  include ::CascadingConfiguration::Hash

  #######################
  #  attribute_indexes  #
  #######################
  
  ###
  #
  # @method attribute_indexes
  #
  # Hash holding attribute indexes: index_name => index.
  #
  # @return [CompositingHash{Symbol,String=>Persistence::Object::Complex::Index::AttributeIndex}]
  #
  attr_hash :attribute_indexes, ::Persistence::Object::IndexHash
      
  ########
  #  ==  # 
  ########

  ###
  # Objects are equivalent if they are identical in standard Ruby terms or if their persistence state is equivalent.
  #
  # @param other_object Object comparing self to
  # 
  # @return [true,false] Whether self is equal to other object.
  #
  def ==( other_object )

    return super( other_object ) || persistence_state_equal?( other_object )
    
  end
  
  ##############################
  #  persistence_state_equal?  #
  ##############################
  
  ###
  # Reports whether objects are equivalent from a persistence perspective.
  #
  # @param other_object Object comparing self to
  # 
  # @return [true,false] Whether self is equal to other object in terms of persisted state.
  #
  def persistence_state_equal?( other_object )

    objects_are_equal = false

    if other_object.is_a?( ::Persistence::Object::Complex::ObjectInstance )  and
       self.class.equal?( other_object.class )                               and
       other_object.respond_to?( :persistence_id )                           and 
       persistence_id == other_object.persistence_id
      
      # test non-atomic attributes for equality
      if objects_are_equal = non_atomic_attribute_readers.empty? or 
         objects_are_equal = ( persistence_hash_to_port == other_object.persistence_hash_to_port )
      
        # test atomic attributes for equality
        unless atomic_attribute_readers.empty?
      
          atomic_attribute_readers.each do |this_attribute|
            this_value = __send__( this_attribute )
            this_other_value = other_object.__send__( this_attribute )
            break unless objects_are_equal = ( this_value == this_other_value )
          end
          
        end
        
      end
      
    end
    
    return objects_are_equal
    
  end

  ##############
  #  persist!  #
  ##############

  def persist!( *args )

    this_call_generates_id = ( persistence_id ? false : true )

    super
    
    if this_call_generates_id
      remove_atomic_attribute_values
    end    

    # index object attributes    
    index_attributes

    return self
  
  end

  ######################
  #  index_attributes  #
  ######################
  
  ###
  # @private
  #
  # Perform indexing on attributes with indexes.
  #
  # @return self
  #
  def index_attributes

    attribute_indexes.each do |this_attribute_name, this_attribute_index|
      this_attribute_index.index_object( self )
    end
    
    return self

  end

  #############
  #  persist  #
  #############
  
  def persist( *args )

    index_instance, key, no_key = parse_args_for_index_value_no_value( args )

    unless persistence_id
      if no_key
        raise ::Persistence::Exception::KeyValueRequired, 
              'Key value required if persistence ID does not already exist for self. : ' + args.to_s
      end
      unless self.persistence_id = index_instance.get_object_id( key )
        # if we got no persistence id, return nil
        return nil
      end
    end
    
    persistence_hash_from_port = persistence_bucket.get_object_hash( persistence_id )
    load_persistence_hash( persistence_port, persistence_hash_from_port )
    
    return self

  end

  ############
  #  cease!  #
  ############

  def cease!
    
    global_id = persistence_id
    
    if persistence_hash_in_port = super

      persistence_hash_in_port.each do |this_attribute, this_value|

        if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject ) and 
           this_value.delete_cascades?

          this_value.cease!

        end

      end

    end
    
    self.persistence_id = nil
    
    return self
    
  end

  ###################
  #  get_attribute  #
  ###################
 
  ####
  # @private
  #
  # Method used when defining implicit getter for attr_atomic/attr_non_atomic.
  #
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

  ####
  # @private
  #
  # Method used when defining implicit setter for attr_atomic/attr_non_atomic.
  #
  def set_attribute( attribute, value )
    
    variable_name = attribute.variable_name
    
    # if we're atomic and have an ID, put to persistence port
    if persistence_id and atomic_attribute?( attribute )
      
      if is_complex_object?( value )
        instance_variable_set( variable_name, value )
      end

      value = persist_as_sub_object_or_attribute_and_return_id_or_value( value )

      persistence_bucket.put_attribute!( self, attribute, value )

      if self.class.has_attribute_index?( attribute )
         attribute_indexes[ attribute ].index_object( self )
      end
      
    # otherwise get from object
    else

      instance_variable_set( variable_name, value )

    end

    return value
    
  end

  #######################
  #  load_atomic_state  #
  #######################
  
  ###
  # Helper method to load atomic state into object so that it can be inspected.
  #
  # @return self
  #
  def load_atomic_state
    
    atomic_attribute_readers.each do |this_attribute|
      instance_variable_set( this_attribute.variable_name, __send__( this_attribute ) )
    end
    
    return self
    
  end

  ###############################################################
  #  persist_as_sub_object_or_attribute_and_return_id_or_value  #
  ###############################################################
 
  ###
  # @private
  #
  # Helper method for persistence for nested objects.
  #
  def persist_as_sub_object_or_attribute_and_return_id_or_value( value )
  
    if is_complex_object?( value ) and ! self.class.persists_flat?( value )

      value.persist!

      sub_id_or_attribute_value = ::Persistence::Object::Complex::ComplexObject.new( value )

    else

      sub_id_or_attribute_value = value

    end
  
    return sub_id_or_attribute_value
    
  end

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  ###
  # @private
  #
  # Generate hash representing object.
  #
  # @return [Hash] Hash representing information to reproduce object instance.
  #
  def persistence_hash_to_port

    persistence_hash = ::Persistence::Object::Complex::Attributes::HashToPort.new
    persistence_hash.persistence_object = self

    persistent_attribute_writers.each do |this_attribute|
      persistence_hash[ this_attribute ] = __send__( this_attribute )
    end

    return persistence_hash

  end

  ###########################
  #  load_persistence_hash  #
  ###########################

  ###
  # @private
  # 
  # Helper method for creating object when persisting from storage port.
  #
  # @param port Storage port object is being loaded from.
  #
  # @param persistence_ivar_hash Hash of data from storage port.
  #
  # @return self
  #
  def load_persistence_hash( port, persistence_ivar_hash )

    self.persistence_port = port

    persistence_ivar_hash.each do |this_attribute_name, this_attribute_value|

      if this_attribute_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        this_attribute_value = this_attribute_value.persist
      end
      
      load_persistence_value( this_attribute_name, this_attribute_value )
      
    end

    return self

  end
  
  ############################
  #  load_persistence_value  #
  ############################
  
  ###
  # @private
  #
  # Helper method for loading data from persistence hash from storage port.
  #
  # @param attribute_name Attribute being loaded.
  #
  # @param attribute_value Attribute value to load.
  #
  # @return self
  #
  def load_persistence_value( attribute_name, attribute_value )
    
    __send__( attribute_name.write_accessor_name, attribute_value )
  
    return self
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ####################################
  #  remove_atomic_attribute_values  #
  ####################################
  
  ###
  # Helper method for initial persistence to storage port to remove atomic variables once persistence ID
  #   has been created.
  #
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
  
  ###
  # Helper method to query whether object should be treated as a complex object.
  #
  # @param object Object to test
  #
  # @return [true,false] Whether object should be treated as a complex object.
  #
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
