
#---------------------------------------------------------------------------------------------------------#
#-----------------------------------------  Object Instance  ---------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::Instance::Object

	include Rpersistence::KlassAndInstance::ParsePersistenceArguments

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
		if @__rpersistence__id__
			raise "Object already has ID; cannot specify new ID."
		end
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
            key_source  = ( '@' + key_source.to_s ).to_sym
          
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

  ################
  #  persisted?  #
  ################

	def persisted?
		return self.class.persisted( persistence_key ) ? true : false
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

    # we know this object needs to be evaluated as a persistence object
    class << self.class
#      include( Rpersistence::Instance::Equals )
    end

		# return the object we're persisting
		return self

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
	def cease!
		persistence_port.adapter.delete_object!( self )
	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

	# these are not actually private, but they're not intended for use

  ###############
  #  ivar_hash  #
  ###############

  # returns persistence hash unique key => storage data
  # unique key is an array
  # adapter responsible for constructing actual storage schema for unique identifier described by key
	def ivar_hash

		ivar_hash	=	Hash.new
		
		instance_variables.each do |property_name|

			unless  property_name.to_s.slice( 0, 17 ) == "@__rpersistence__"  or 
			        ( persists_all_ivars?   and non_persistent_attribute?( property_name ) )  or
			        ( ! persists_all_ivars? and persistent_attribute?( property_name ) )

			  ivar_hash[ property_name ] = instance_variable_get( property_name )

      end
      
		end
		
		return ivar_hash

	end

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  # returns persistence hash unique key => storage data
  # unique key is an array
  # adapter responsible for constructing actual storage schema for unique identifier described by key
	def persistence_hash_to_port

		persistence_hash_to_port	=	Hash.new
		
		instance_variables.each do |property_name|

			#	we don't want to store rpersistence variables and we need to make sure each variable should be persisted
			unless  property_name.to_s.slice( 0, 17 ) == "@__rpersistence__"  or 
			        ( persists_all_ivars?   and non_persistent_attribute?( property_name ) )  or
			        ( ! persists_all_ivars? and persistent_attribute?( property_name ) )

				persistence_hash_to_port[ primary_key_for_object_and_property_name( property_name ) ] = instance_variable_get( property_name )

        # if this is the first time persisting we are likely to have instance variables that are intended to function atomically
        # if this is the case, we want to remove them from instance_vars as we add them to the hash
        if instance_variable_defined?( :@__rpersistence__first_persist__ )
          
          accessor_method_name, property_name  = accessor_name_for_var_or_method( property_name, false )        

          remove_instance_variable( property_name ) if atomic_attribute?( accessor_method_name )
          
        end
        
			end

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
      
      atomic_property_variable_name = ( '@' + atomic_property_name.to_s ).to_sym
      
      if instance_variables.include?( atomic_property_variable_name )
        puts 'removing var: ' + atomic_property_variable_name.to_s
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
