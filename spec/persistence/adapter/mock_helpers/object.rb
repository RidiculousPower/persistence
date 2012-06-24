
class ::Persistence::Adapter::Abstract::Mock::Object

  include ::CascadingConfiguration::Setting
  attr_class_configuration :instance_persistence_bucket, :instance_persistence_port
  attr_local_configuration :adapter, :persistence_bucket, :persistence_port
  attr_instance_setting :persistence_id
  attr_object_configuration :instance_persistence_bucket
  include ::CascadingConfiguration::Hash
  
  attr_accessor :value, :name
  
  #######################################
  #  self.non_atomic_attribute_readers  #
  #######################################

  def self.non_atomic_attribute_readers
    return @non_atomic_attribute_readers ||= [ ]
  end
  
  ##############################
  #  persistence_hash_to_port  #
  ##############################
  
  def persistence_hash_to_port
    persistence_hash = { }
    instance_variables.each do |this_variable|
      persistence_hash[ this_variable ] = instance_variable_get( this_variable )
    end
    return persistence_hash
  end

  ######################
  #  persistence_port  #
  ######################

  def persistence_port
    return super || self.class.instance_persistence_port
  end

  ########################
  #  persistence_bucket  #
  ########################

  def persistence_bucket
    return super || self.class.instance_persistence_bucket
  end

  ###########################
  #  load_persistence_hash  #
  ###########################

  def load_persistence_hash( port, persistence_hash )
    persistence_hash.each do |this_variable, this_value|
      instance_variable_set( this_variable, this_value )
    end
  end
  
  ##################################
  #  non_atomic_attribute_readers  #
  ##################################
  
  def non_atomic_attribute_readers
    return [ ]
  end
  
  ##############################
  #  atomic_attribute_readers  #
  ##############################
  
  def atomic_attribute_readers
    return [ ]
  end

  ##############
  #  persist!  #
  ##############

  def persist!
    
    persistence_bucket.put_object!( self )
    
    return self
    
  end
  
end
