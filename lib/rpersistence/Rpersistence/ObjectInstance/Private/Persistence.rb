
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------- Object Persistence  ----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Persistence

  #########################################
  #  Klass.primary_key_for_property_name  #
  #  primary_key_for_property_name        #
  #########################################

  def primary_key_for_property_name( property_name )

		return [ 	persistence_id, 
							persistence_locale, 
							persistence_version, 
							property_name, 
							( complex_property?( persistence_port, property_name ) ? true : false ),
							( delete_cascades?( persistence_port, property_name ) ? true : false ) ]

  end

  ###########################################################################################################
      private ###############################################################################################
  ###########################################################################################################

  ############################################
  #  Klass::instance_variables_as_accessors  #
  #  instance_variables_as_accessors         #
  ############################################

  def instance_variables_as_accessors

    instance_vars_as_accessors  = Array.new
    
    instance_variables.each do |this_var|
      instance_vars_as_accessors.push( accessor_name_for_variable( this_var ) )
    end

    return instance_vars_as_accessors

  end
  
  ##################################
  #  Klass::load_persistence_hash  #
  #  load_persistence_hash         #
  ##################################

  def load_persistence_hash( port, persistence_ivar_hash )

    persistence_port = port
    persistence_id   = persistence_ivar_hash.delete( :@__rpersistence__id__ )

    unless is_a?( Hash ) or is_a?( Array )
      
      # we know this object needs to be evaluated as a persistence object
      self.extend( Rpersistence::ObjectInstance::Equality )
      
    end
      
    persistence_ivar_hash.each do |property_name, property_value|

      # if we have an array it is a complex object: [ klass, { sub_object_values } ]
      if property_value.is_a?( Array )
        complex_sub_object_klass      = property_value[ 0 ]
        complex_sub_object_value_hash = property_value[ 1 ]
        property_value                = object_from_persistence_hash( port, complex_sub_object_klass, complex_sub_object_value_hash )
        property_value.instance_eval do
          declare_complex_property( property_name )
        end
      else
        declare_flat_object( property_name )
      end

      # set in object
      if is_a?( Hash )
        self[ property_name ] = property_value
      elsif is_a?( Array )
        push( property_value )
      else
        object_instance_variable_set( property_name, property_value )
      end

    end

    return self
    
  end

  #####################################
  #  Klass::persistence_hash_to_port  #
  #  persistence_hash_to_port         #
  #####################################

  # returns persistence hash unique key => storage data
  # unique key is an array
  # adapter responsible for constructing actual storage schema for unique identifier described by key
	def persistence_hash_to_port

		persistence_hash_to_port	=	Hash.new

    if self.class == Array

  		self.each_with_index do |property_value, index|

        property_value                            = persist_value_as_sub_object_if_necessary_and_return_id_or_value( index, property_value )
        primary_key                               = primary_key_for_property_name( index )
				persistence_hash_to_port[ primary_key ]   = property_value

  		end

    elsif self.class == Hash

  		self.each do |property_name, property_value|

        property_value                            = persist_value_as_sub_object_if_necessary_and_return_id_or_value( property_name, property_value )
        primary_key                               = primary_key_for_property_name( property_name )
				persistence_hash_to_port[ primary_key ]   = property_value

  		end
      
    else

  		instance_variables_minus_persistence_variables.each do |property_name|

  			#	we don't want to store rpersistence variables, atomic attributes, or non-persistent attributes
  			if persistent_attribute?( property_name )

          property_value                          = object_instance_variable_get( property_name )
          property_value                          = persist_value_as_sub_object_if_necessary_and_return_id_or_value( property_name, property_value )
          primary_key                             = primary_key_for_property_name( property_name )
  				persistence_hash_to_port[ primary_key ] = property_value

  			end

  		end
      
    end

		return persistence_hash_to_port

	end

  #####################################
  #  Klass::declare_complex_property  #
  #  declare_complex_property         #
  #####################################

  def declare_complex_property( variable_name )

    @__rpersistence__complex_property__	||=	Hash.new

    @__rpersistence__complex_property__[ variable_name ]  = true

  end

  ################################
  #  Klass::declare_flat_object  #
  #  declare_flat_object         #
  ################################

  def declare_flat_object( variable_name )

    @__rpersistence__complex_property__	||=	Hash.new

    @__rpersistence__complex_property__[ variable_name ]  = false

  end

  ##############################
  #  Klass::complex_property?  #
  #  complex_property?         #
  ##############################

  def complex_property?( port, variable_name )
    
    @__rpersistence__complex_property__	||=	Hash.new

    # a complex object is an object with more than one property
    
    complex_property = @__rpersistence__complex_property__[ variable_name ]
    
    if complex_property == nil

      complex_property  = port.adapter.complex_property?( self, variable_name )
      
      @__rpersistence__complex_property__[ variable_name ] = complex_property
    
    end

    return complex_property
    
  end

  #############################
  #  Klass::delete_cascades?  #
  #  delete_cascades?         #
  #############################

  def delete_cascades?( port, variable_name )

    @__rpersistence__delete_cascades__	||=	Hash.new

    delete_cascades = @__rpersistence__delete_cascades__[ variable_name ]
    
    if delete_cascades == nil

      delete_cascades  = port.adapter.delete_cascades?( self, variable_name )
      
      @__rpersistence__delete_cascades__[ variable_name ] = delete_cascades
    
    end

    return delete_cascades

	end
	
  ############################################################################
  #  Klass::persist_value_as_sub_object_if_necessary_and_return_id_or_value  #
  #  persist_value_as_sub_object_if_necessary_and_return_id_or_value         #
  ############################################################################
 
  def persist_value_as_sub_object_if_necessary_and_return_id_or_value( variable_name, value )
  
    sub_object_id_or_value = nil
  
    klass = value.class
    if  klass == Bignum       or
        klass == Fixnum       or
        klass == Complex      or
        klass == Rational     or
        klass == TrueClass    or
        klass == FalseClass   or
        klass == String       or
        klass == Symbol       or
        klass == Regexp       or
        klass == File         or
        klass == File::String or
        klass == NilClass

      declare_flat_object( variable_name )
      sub_object_id_or_value  = value

    else
      
      declare_complex_property( variable_name )        

      # set reference to our object in self
      object_instance_variable_set( variable_name, value )

      # set object's port to this port; cannot persist a single complex object across multiple ports
      value.persistence_port = persistence_port

      # if our parent object already exists then we need to see if we already have an ID stored for this property
      # if so then we need to use the existing ID to store this object
      
      # we can set the id without checking because we don't have an ID yet so will get the existing ID or nil
      value.persistence_id  = persistence_port.adapter.get_property( self, variable_name )
      
      value.persist!

      sub_object_id_or_value = value.persistence_id

    end
  
    return sub_object_id_or_value
    
  end
  
  ########################################
  #  Klass::remove_atomic_instance_vars  #
  #  remove_atomic_instance_vars         #
  ########################################
  
  def remove_atomic_instance_vars
        
    atomic_instance_vars  = atomic_attributes
    
    if atomic_instance_vars
      atomic_instance_vars.each do |atomic_property_name|
      
        atomic_property_variable_name = variable_name_for_accessor( atomic_property_name )
      
        if object_instance_variables.include?( atomic_property_variable_name )
          remove_instance_variable( atomic_property_variable_name )
        end
      
      end
    end
    
  end

  ##############################
  #  Klass::load_atomic_state  #
  #  load_atomic_state         #
  ##############################
  
  def load_atomic_state
    
    attributes  = atomic_attributes
    
    if attributes
      attributes.each do |this_attribute|
        instance_variable_set( variable_name_for_accessor( this_attribute ) , __send__( this_attribute ) )
      end
    end
    
    return self
    
  end

  #########################################
  #  Klass::object_from_persistence_hash  #
  #  object_from_persistence_hash         #
  #########################################
  
  def object_from_persistence_hash( port, klass, persistence_ivar_hash )

    object = klass.new
    
    object.instance_eval do
      load_persistence_hash( port, persistence_ivar_hash )
    end
    
		return object

  end
  
end
