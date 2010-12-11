
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

	def persistence_hash
		# if we are persisting everything we also want instance variables
		if class.persists_everything
			instance_variables.inject( {} ) do |persistence_hash, property_name|
				persistence_hash[ storage_key_for_property( self, property_name ) ] = instance_variable_get( property_name )
				persistence_hash
			end
		end
		
		# hash always includes declared elements
		class.declared_elements
		
	end

  ################
  #  persisted?  #
  ################

	def persisted?
		
	end

  ############
  #  cease!  #
  ############

	def cease!
		
	end

  ###########################################################################################################
  #############################################  Private  ###################################################
  ###########################################################################################################

  ##############################
  #  storage_key_for_property  #
  ##############################
  
  def storage_key_for_property( property_name )
		return {  :global_persistence_id    =>  persistence_id, 
		          :property_name            =>  property_name )
  end  

end