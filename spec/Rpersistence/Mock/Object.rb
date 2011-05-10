
class Rpersistence::Mock::Object

  attr_accessor :some_value, :persistence_port, :adapter

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

  ######################
  #  persistence_port  #
  ######################

  def persistence_port
    return @__rpersistence__persistence_port__
  end

  #######################
  #  persistence_port=  #
  #######################

  def persistence_port=( port )
     @__rpersistence__persistence_port__ = port
    return self
  end

  ############################
  #  persistence_key_source  #
  ############################

  def persistence_key_source
    return :some_value
  end

  #######################################
  #  persistence_key_source_is_method?  #
  ######################################

  def persistence_key_source_is_method?
    return true
  end

  ############################
  #  instance_variable_hash  #
  ############################

  def instance_variable_hash
    instance_variable_hash = Hash.new
    instance_variables.each do |property_name|
      property_value                            = instance_variable_get( property_name )
      instance_variable_hash[ property_name ] = property_value
    end
    return instance_variable_hash
  end

end
