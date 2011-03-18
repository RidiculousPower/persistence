
module Rpersistence::Instance::Object

	include Rpersistence::KlassAndInstance::ParsePersistenceArguments

  ####################
  #  persistence_id  #
  ####################

  def persistence_id
    return @__rpersistence_id__
  end

  #####################
  #  persistence_id=  #
  #####################

  def persistence_id=( id )
		if @__rpersistence_id__
			raise "Object already has ID; cannot specify new ID."
		end
    @__rpersistence_id__  = id
  end

  #############################
  #  reset_persistence_id_to  #
  #############################

	def reset_persistence_id_to( new_id )
		@__rpersistence_id__	=	new_id
	end

  ########################
  #  persistence_bucket  #
  ########################
  
  def persistence_bucket
		rpersistence_bucket = nil
		if @__rpersistence_bucket__
    	rpersistence_bucket = @__rpersistence_bucket__
		else
			# default persistence bucket is classname as string
			rpersistence_bucket = ( self.class == Class ? self.to_s : self.class.to_s )
		end
		return rpersistence_bucket
  end

  #####################
  #  persistence_key  #
  #####################
  
  def persistence_key
		rpersistence_key_value	=	nil
		# if we have a key method specified, use it
		if @__rpersistence_key_method__
    	rpersistence_key_value = __send__( @__rpersistence_key_method__ )
		# otherwise the default value is to return any arbitrarily specified key (or nil)
		else
			rpersistence_key_value = @__rpersistence_key__
		end
		return rpersistence_key_value
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

  ######################
  #  persistence_hash  #
  ######################

  # returns persistence hash unique key => storage data
  # unique key is an array
  # adapter responsible for constructing actual storage schema for unique identifier described by key
	def persistence_hash
		# if we are persisting everything we also want instance variables
		if self.class.persists_everything
			instance_variables.inject( {} ) do |persistence_hash, property_name|
				persistence_hash[ rpersistence_key_for_object_and_property_name( property_name ) ] = instance_variable_get( property_name )
				persistence_hash
			end
		end
		# hash always includes declared elements
		self.class.declared_elements.each do |this_element, read_write_status|
		  if read_write_status == :writer or read_write_status == :accessor
		    persistence_hash[ rpersistence_key_for_object_and_property_name( this_element ) ] = __send__.( this_element )
	    end
	  end
		return persistence_hash
	end

  ################
  #  persisted?  #
  ################

	def persisted?
		return self.class.persisted( self.persistence_key ) ? true : false
	end

  ##############
  #  persist!  #
  ##############

	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
	def persist!( *args )

		port, bucket, persistence_key = parse_persist_args( args )
		
		port.adapter.put_object_to_persistence_port!( bucket, persistence_key, self, rpersistence_hash )

		# return the object we're persisting
		return self

	end

  #######################
  #  stop_persistence!  #
  #######################
  
  # suspend atomic writes and quietly suppress explicit calls to persist!
  def stop!
    @__rpersistence_stopped__  = true
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
    @__rpersistence_suspended__  = true
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
    @__rpersistence_suspended__  	= false
    @__rpersistence_stopped__  		= false
  end
  
  ############
  #  cease!  #
  ############

	# deletes from storage (archives if appropriate)
	def cease!
		persistence_port.adapter.delete_object_from_persistence_port!( self )
	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

	# these are not actually private, but they're not intended for use

  #######################
  #  rpersistence_hash  #
  #######################

	def rpersistence_hash
		persistence_hash	=	Hash.new
		self.instance_variables.each do |property_name|
			persistence_hash[ property_name ] = self.instance_variable_get( property_name )
		end
		#	and remove rpersistence variables
		persistence_hash.delete( :@__rpersistence_id__ )
		persistence_hash.delete( :@__rpersistence_port__ )
		persistence_hash.delete( :@__rpersistence_bucket__ )
		persistence_hash.delete( :@__rpersistence_key__ )
		persistence_hash.delete( :@__rpersistence_key_method__ )
		persistence_hash.delete( :@__rpersistence_stopped__ )
		persistence_hash.delete( :@__rpersistence_suspended__ )
		return persistence_hash
	end

  ###################################################
  #  rpersistence_key_for_object_and_property_name  #
  ###################################################

  def rpersistence_key_for_object_and_property_name( property_name = nil )
		return [ persistence_id, persistence_key, persistence_locale, persistence_version, property_name ]
  end

  private

end

class Object
	include Rpersistence::Instance::Object
end
