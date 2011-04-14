
class Rpersistence
	module Mock
	end
end

class Rpersistence::Mock::Object

  #####################
  #  persistence_id=  #
  #####################

  def persistence_id=( id )
		@__rpersistence__persistence_id__ = id
  end

  ####################
  #  persistence_id  #
  ####################

  def persistence_id
		return @__rpersistence__persistence_id__
  end

  ##########################
  #  has_persistence_key?  #
  ##########################

  def has_persistence_key?
    # return false to force ID creation without testing :get_object_id_for_bucket_and_key
    return false
  end

  ########################
  #  persistence_bucket  #
  ########################

  def persistence_bucket
    return self.class.to_s
  end

  #####################
  #  persistence_key  #
  #####################

  def persistence_key
    return 'persistence_key'
  end

  ###################################
  #  primary_key_for_property_name  #
  ###################################

  def primary_key_for_property_name( property_name )
		return property_name
  end

  ############################
  #  instance_variable_hash  #
  ############################

	def instance_variable_hash
		instance_variable_hash = Hash.new
		instance_variables.each do |property_name|
      property_value                          	= instance_variable_get( property_name )
			instance_variable_hash[ property_name ] = property_value
		end
		return instance_variable_hash
	end

  ##############################
  #  persistence_hash_to_port  #
  ##############################
	
	def persistence_hash_to_port
		persistence_hash_to_port = Hash.new
		instance_variables.each do |property_name|
      property_value                          = instance_variable_get( property_name )
      primary_key                             = primary_key_for_property_name( property_name )
			persistence_hash_to_port[ primary_key ] = property_value
		end
		return persistence_hash_to_port
	end

end
