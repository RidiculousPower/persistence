
module Rpersistence::Instance::Object

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
		id.freeze unless id.frozen?
    @__rpersistence_id__  = id
  end

  ########################
  #  persistence_bucket  #
  ########################
  
  def persistence_bucket
    return @__rpersistence_bucket__
  end

  #####################
  #  persistence_key  #
  #####################
  
  def persistence_key
    return @__rpersistence_key__
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
				persistence_hash[ rpersistence_property_name_for_property( self, property_name ) ] = instance_variable_get( property_name )
				persistence_hash
			end
		end
		# hash always includes declared elements
		self.class.declared_elements.each do |this_element, read_write_status|
		  if read_write_status == :writer or read_write_status == :accessor
		    persistence_hash[ rpersistence_property_name_for_property( self, this_element ) ] = __send__.( this_element )
	    end
	  end
		return persistence_hash
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

	def persist!
		persistence_port.adapter.put_object_to_persistence_port!( self )
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

	# these are not actually private, but you're still not intended to be using them

  ###########################################
  #  rpersistence_property_name_for_property  #
  ###########################################

  def rpersistence_property_name_for_property( property_name )
		return [ persistence_id, property_name ]
  end

  private

end

class Object
	include Rpersistence::Instance::Object
end
