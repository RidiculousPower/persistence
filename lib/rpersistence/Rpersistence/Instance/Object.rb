
#---------------------------------------------------------------------------------------------------------#
#-----------------------------------------  Object Instance  ---------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::Instance::Object

	include Rpersistence::KlassAndInstance::ParsePersistenceArguments

  # this gets used to distinguish object instance variables and atomic instance variables
  # not utilized until Rpersistence::Instance::Variables is included (after persist! or persist)
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

    include_or_extend_for_persistence_if_necessary
    
		# return the object we're persisting
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
  
  ############
  #  cease!  #
  ############

	# deletes from storage (archives if appropriate)
	def cease!( *args )

		port, bucket, key = parse_persist_args( args )

    global_id = persistence_id
    unless global_id
      global_id = port.adapter.get_object_id_for_bucket_and_key( bucket, key )
    end

		port.adapter.delete_object!( global_id )
		
    remove_instance_variable( :@__rpersistence__id__ )

	end

  ############################################  Variables  ##################################################

  #####################################
  #  instance_variables_as_accessors  #
  #####################################

  def instance_variables_as_accessors

    instance_vars_as_accessors  = Array.new
    
    instance_variables.each do |this_var|
      instance_vars_as_accessors.push( accessor_name_for_variable( this_var ) )
    end

    return instance_vars_as_accessors

  end
  
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

  ########################
  #  instance_variables  #
  ########################

  def instance_variables

    ivar_array	=	Array.new
		
		# first - anything we've stored in object
		object_instance_variables.each do |property_name|

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

      instance_variable = persistence_port.adapter.get_property( self, variable_name )
    
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
    
    # if we're atomic and have an ID, get from persistence port (call accessor write method)
    if persistence_id and atomic_attribute?( variable_name )
    
      persistence_port.adapter.put_property!( self, variable_name, value )
    
    # otherwise get from object
    else
      
      object_instance_variable_set( variable_name, value )
      
    end
    
    return self
    
  end
  
  #############
  #  inspect  #
  #############

  def inspect

    require 'pp'
    
    load_atomic_state
    value_string_array              = instance_variables_hash.collect{ |property_name, property_value| property_name.to_s + '=' + property_value.pretty_inspect.chomp.to_s }
    instance_variable_names_values  = value_string_array.join( ' ' )
    instance_variable_string        = ( instance_variables_hash.empty?  ? '' : ' ' + instance_variable_names_values )

    inspect_string = nil

    if self.class == Class
      inspect_string  = self.class.to_s
    else
      inspect_string  = '<' + self.class.to_s + ':' + self.__id__.to_s + instance_variable_string + '>'
    end
    
    return inspect_string
        
  end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  #######################
  #  load_atomic_state  #
  #######################
  
  def load_atomic_state
    
    attributes  = atomic_attributes
    
    if attributes
      attributes.each do |this_attribute|
        instance_variable_set( variable_name_for_accessor( this_attribute ) , __send__( this_attribute ) )
      end
    end
    
    return self
    
  end
  
  ##############################
  #  persistence_hash_to_port  #
  ##############################

  # returns persistence hash unique key => storage data
  # unique key is an array
  # adapter responsible for constructing actual storage schema for unique identifier described by key
	def persistence_hash_to_port

		persistence_hash_to_port	=	Hash.new
		object_instance_variables.each do |property_name|

			#	we don't want to store rpersistence variables, atomic attributes, or non-persistent attributes
			if persistent_attribute?( property_name )

        primary_key = primary_key_for_object_and_property_name( property_name )
				persistence_hash_to_port[ primary_key ] = instance_variable_get( property_name )
        
			end

		end
		

    # if this is the first time persisting we are likely to have instance variables that are intended to function atomically
    # if this is the case, we want to remove them from instance_vars as we add them to the hash
    if instance_variable_defined?( :@__rpersistence__first_persist__ )
      
      remove_atomic_instance_vars
      
    end

		return persistence_hash_to_port

	end

  ##############################################
  #  primary_key_for_object_and_property_name  #
  ##############################################

  def primary_key_for_object_and_property_name( property_name = nil )

		return [ persistence_id, persistence_locale, persistence_version, property_name ]

  end

  private

  #################################
  #  remove_atomic_instance_vars  #
  #################################
  
  def remove_atomic_instance_vars
        
    atomic_attributes.each do |atomic_property_name|
      
      atomic_property_variable_name = variable_name_for_accessor( atomic_property_name )
      
      if object_instance_variables.include?( atomic_property_variable_name )
        remove_instance_variable( atomic_property_variable_name )
      end
      
    end
    
  end

end

#---------------------------------------------------------------------------------------------------------#
#--------------------------------------------  Includes  -------------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

class Object
	include Rpersistence::Instance::Object
end
