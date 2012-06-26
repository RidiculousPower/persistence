
###
# Class used for persisting references to other complex objects nested inside a complex object.
# 
class ::Persistence::Object::Complex::ComplexObject < ::String

  include CascadingConfiguration::Setting
  
  ################
  #  initialize  #
  ################

  ###
  #
  # @param object Object for which ComplexObject instance is used.
  #
  def initialize( object )
    
    super( object.persistence_id.to_s )
    
    self.persistence_port = object.persistence_port
    self.persistence_bucket = object.persistence_bucket
  
  end

  #####################
  #  delete_cascades  #
  #####################
  
  ###
  # @!attribute [writer] Whether this object should be deleted when its parent is deleted.
  #
  attr_writer :delete_cascades

  #############
  #  persist  #
  #############
  
  ###
  # Store object to persistence bucket.
  #
  def persist
    
    global_id = persistence_id
    klass = persistence_port.get_class_for_object_id( global_id )
    
    return klass.persist( global_id )
    
  end

  ####################
  #  persistence_id  #
  ####################
  
  ###
  # Get persistence ID.
  #
  def persistence_id

    return to_i

  end

  ######################
  #  persistence_port  #
  ######################
  
  ###
  # @method persistence_port
  # 
  # Get object's persistence port.
  #
  attr_instance_setting :persistence_port
  
  ########################
  #  persistence_bucket  #
  ########################
  
  attr_instance_setting :persistence_bucket
  
  ###
  # Get object's persistence bucket.
  #
  def persistence_bucket
    
    unless return_bucket = super
      return_bucket = persistence_port.get_bucket_name_for_object_id( persistence_id )
      self.persistence_bucket = return_bucket
    end
    
    return return_bucket
    
  end
  
  ######################
  #  delete_cascades?  #
  ######################
  
  ###
  # Query whether object should be deleted when parent object is deleted.
  #
  # @return [true,false] Whether object delete should cascade.
  #
  def delete_cascades?

    return @delete_cascades

  end

end

