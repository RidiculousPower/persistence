
#-----------------------------------------------------------------------------------------------------------#
#---------------------------------------- Object Persistence  ----------------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Persistence

	include Rpersistence::ObjectInstance::ParsePersistenceArgs

  # this gets used to distinguish object instance variables and atomic instance variables
  # not utilized until Rpersistence::ObjectInstance::Equality is included (after persist! or persist)
  alias_method :object_instance_variables,    :instance_variables
  alias_method :object_instance_variable_get, :instance_variable_get
  alias_method :object_instance_variable_set, :instance_variable_set

  ####################
  #  persistence_id  #
  ####################

  def persistence_id
    return @__rpersistence__id__
  end

  #####################
  #  persistence_id=  #
  #####################

  def persistence_id=( id )
    @__rpersistence__id__  = id
  end

  #############################
  #  reset_persistence_id_to  #
  #############################

	def reset_persistence_id_to( new_id )
		@__rpersistence__id__	=	new_id
	end

  #####################
  #  persistence_key  #
  #####################
  
  def persistence_key

		key_value	=	nil

		# if we have a key method specified, use it
		if key_source = persistence_key_source

      if persistence_key_source_is_method?
        
        # if we don't have an id or if this is our first time persisting then we can't read atomically yet
        if ! persistence_id or instance_variable_defined?( :@__rpersistence__first_persist__ )
          
          # if we have a previous method, call it for our source
          if accessor_has_prior_method?( @__rpersistence__key_source__, :reader )
          
            prior_accessor_method  = name_for_prior_accessor( accessor_method_name, :reader )
          
            key_value = __send__( prior_accessor_method )
          
          # otherwise, use instance_variable_get
          else
          
            # we need the variable name from our method name
            key_source  = variable_name_for_accessor( key_source )
          
            key_value   = instance_variable_get( key_source )
        	
          end
          
        else

      	  key_value = __send__( key_source )
          
        end
        
      else
        
    	  key_value = instance_variable_get( key_source )

      end

		# otherwise the default value is to return any arbitrarily specified key (or nil)
		else

			key_value = @__rpersistence__arbitrary_key__

		end

		return key_value

  end

  ########################
  #  persistence_locale  #
  ########################
  
  def persistence_locale
		#	implemented in separate module
    return nil
  end

  #########################
  #  persistence_version  #
  #########################
  
  def persistence_version
		#	implemented in separate module
    return nil
  end

  ##########################
  #  has_persistence_key!  #
  ##########################
  
  def has_persistence_key!
    @__rpersistence__has_persistence_key__ = true
  end

  ##########################
  #  has_persistence_key?  #
  ##########################
  
  def has_persistence_key?
    
    has_key = false
    
    if instance_variable_defined?( :@__rpersistence__has_persistence_key__ )
      
      has_key = @__rpersistence__has_persistence_key__
      
    elsif self.class != Class
      
      has_key = self.class.has_persistence_key?
    
    end
    
    return has_key
  end  

  ##############
  #  persist!  #
  ##############

	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
	def persist!( *args )

    # if we don't have an ID, mark that this is the first persist
    @__rpersistence__first_persist__  = true unless @__rpersistence__id__

		port, bucket, key = parse_persist_args( args )
		port.adapter.put_object!( self )
    remove_atomic_instance_vars

    # if this was the first persist, unmark (we have ID now)
    remove_instance_variable( :@__rpersistence__first_persist__ ) if instance_variable_defined?( :@__rpersistence__first_persist__ )
    # if we were forcing new id, remove setting now (we have our new ID)
    remove_instance_variable( :@__rpersistence__force_new_id__ ) if instance_variable_defined?( :@__rpersistence__force_new_id__ )

    include_or_extend_for_persistence_if_necessary
    
		# return the object we're persisting
		return self

	end

  #############
  #  persist  #
  #############
  
	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
  def persist( *args )

		port, bucket, key = parse_persist_args( args )

    persistence_id    = persistence_port.adapter.get_object_id_for_bucket_and_key( bucket, key ) unless persistence_id

		if persistence_id
      
      load_persistence_hash( port, persistence_hash_from_port( port, persistence_id ) )
        
    else
      
      # signify that we did not find an existing self
      return nil
      
    end
    
    return self

  end
  
  ################
  #  persisted?  #
  ################

	def persisted?( *args )

    is_persisted  = ( persistence_port.adapter.get_object_id_for_bucket_and_key( persistence_bucket, persistence_key ) ? true : false )
	  
    return is_persisted
    
	end

  #######################
  #  stop_persistence!  #
  #######################
  
  # suspend atomic writes and quietly suppress explicit calls to persist!
  def stop!
    @__rpersistence__stopped__  = true
    # if we have a block we stop until the end
    if block_given?
      yield
      resume!
    end
  end

  ##########################
  #  suspend_persistence!  #
  ##########################
  
  # suspend atomic writes and fail explicit calls to persist!
  def suspend!
    @__rpersistence__suspended__  = true
    # if we have a block we suspend until the end
    if block_given?
      yield
      resume!
    end
  end

  #########################
  #  resume_persistence!  #
  #########################
  
  # resume atomic writes and no longer suppress explicit calls to persist!
  def resume!
    @__rpersistence__suspended__  	= false
    @__rpersistence__stopped__  		= false
  end

  ##############################################  Cease  ####################################################

  ############
  #  cease!  #
  ############

	# deletes from storage (archives if appropriate)
	def cease!( *args )

		port, bucket, key = parse_persist_args( args )

		# if we have a key but no persistence ID and we are told to cease! then we assume an object with this key exists
		# we need its ID
		if ! persistence_id and has_persistence_key?
			persistence_id	=	port.adapter.get_object_id_for_bucket_and_key( bucket, key )
		end

		port.adapter.delete_object!( persistence_id, bucket )
    
    return self
    
	end

  ############################################  Variables  ##################################################

  #############################
  #  instance_variables_hash  #
  #############################

  def instance_variables_hash
    
    ivar_hash	=	Hash.new

		instance_variables.each do |property_name|

		  ivar_hash[ property_name ] = instance_variable_get( property_name )
      
		end
		
		return ivar_hash
		
  end

  ####################################################
  #  instance_variables_minus_persistence_variables  #
  ####################################################

  def instance_variables_minus_persistence_variables
    
    # first - anything we've stored in object
		instance_vars = object_instance_variables.select { |property_name| ( property_name.to_s.slice( 0, 17 ) == "@__rpersistence__" ? false : true ) }

		return instance_vars
		
  end

  ########################
  #  instance_variables  #
  ########################

  def instance_variables

    ivar_array	=	Array.new
		
		# first - anything we've stored in object
		instance_variables_minus_persistence_variables.each do |property_name|

			unless  property_name.to_s.slice( 0, 17 ) == "@__rpersistence__"

			  ivar_array.push( property_name )

      end
      
		end

		# second - atomic properties
		atomic_accessors  = atomic_attributes
		if atomic_accessors
  		# re-name atomic attributes as vars instead of accessors
  		atomic_accessors.each do |this_atomic_accessor|
  		  ivar_array.push( variable_name_for_accessor( this_atomic_accessor ) )
  	  end	
		end

		return ivar_array.sort.uniq
		
  end
  
  ###########################
  #  instance_variable_get  #
  ###########################

  def instance_variable_get( variable_name )

    instance_variable = nil
    
    # if we're atomic and have an ID, get from persistence port (call accessor read method)
    if persistence_id and ! instance_variable_defined?( :@__rpersistence__first_persist__ ) and atomic_attribute?( variable_name )

      # we need to know if we are loading a flat or complex object
      # a complex object is any object that has multiple properties (like the one we are currently in)
      # if we have a complex object then we store its ID
      # the first time we load the property we load the object corresponding to the ID
      # at this point, persistence activity at the level of this object is defined by configuration specific to the object
      # once our object has been loaded we don't need to get it again
      # so we can check to see if the variable is already set to a value, in which case we do not load it from the persistence port
      
      complex = complex_property?( persistence_port, variable_name )
      if complex
        
        instance_variable = object_instance_variable_get( variable_name )        
        
      end

      # if we already have our object (a complex object we already loaded) we can return it
      # otherwise we need to get our object/value
      unless instance_variable

        instance_variable = persistence_port.adapter.get_property( self, variable_name )
        
        # if complex we have an ID
        if complex
          
          klass             = persistence_port.adapter.class_for_persistence_id( this_persistence_value )
          klass.instance_eval do
            instance_variable = object_for_persistence_id( persistence_port, instance_variable )
          end
          
        end
        
      end
      
    # otherwise get from object
    else

      instance_variable = object_instance_variable_get( variable_name )
      
    end
    
    return instance_variable
    
  end
  
  ###########################
  #  instance_variable_set  #
  ###########################

  def instance_variable_set( variable_name, value )

    # if we're atomic and have an ID, put to persistence port
    if persistence_id and atomic_attribute?( variable_name )

      value = persist_value_as_sub_object_if_necessary_and_return_id_or_value( variable_name, value )
            
      # we're always putting our property, whether the value is a flat object or an ID for a complex object
      persistence_port.adapter.put_property!( self, variable_name, value )
      
    # otherwise get from object
    else
      
      object_instance_variable_set( variable_name, value )
      
    end
    
    
    return self
    
  end
    
end
