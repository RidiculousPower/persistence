
module Rpersistence::Object

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
    @__rpersistence_id__  = id.freeze
  end

  #####################
  #  persistence_key  #
  #####################
  
  def persistence_key
    return __send__.( persistence_key_method )
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
				persistence_hash[ storage_key_for_property( self, property_name ) ] = instance_variable_get( property_name )
				persistence_hash
			end
		end
		# hash always includes declared elements
		self.class.declared_elements.each do |this_element, read_write_status|
		  if read_write_status == :writer or read_write_status == :accessor
		    persistence_hash[ storage_key_for_property( self, this_element ) ] = __send__.( this_element )
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

  ##########################
  #  suspend_persistence!  #
  ##########################
  
  # suspend atomic writes
  def suspend!
    @suspended  = true
    # if we have a block we suspend until the end
    if block_given?
      yield
      resume!
    end
  end

  #########################
  #  resume_persistence!  #
  #########################
  
  # resume atomic writes
  def resume!
    @suspended  = false
  end
  
  ############
  #  cease!  #
  ############

	def cease!
		persistence_port.adapter.delete_object_from_persistence_port!( self )
	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  private

  ##############################
  #  storage_key_for_property  #
  ##############################
  
  def storage_key_for_property( property_name )
		return {  :global_persistence_id    =>  persistence_id, 
		          :property_name            =>  property_name }
  end  

  # something to keep track of what's being used for the key?
  # to define the initial environment definition - the definition is mutable, but once defined should be immutable (unless easily changed, or explicitly upgraded)
  

end

class Object
	include Rpersistence::Object
end