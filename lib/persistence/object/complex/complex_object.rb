
class ::Persistence::Object::Complex::ComplexObject < ::String

  include CascadingConfiguration::Setting
  
  attr_instance_configuration :persistence_port, :persistence_bucket
  
  attr_writer :delete_cascades

  ################
  #  initialize  #
  ################

  def initialize( object )
    super( object.persistence_id.to_s )
    self.persistence_port = object.persistence_port
    self.persistence_bucket = object.persistence_bucket
  end

  #############
  #  persist  #
  #############
  
  def persist
    global_id = persistence_id
    klass = persistence_port.get_class_for_object_id( global_id )
    return klass.persist( global_id )
  end

  ####################
  #  persistence_id  #
  ####################
  
  def persistence_id
    return to_i
  end
  
  ########################
  #  persistence_bucket  #
  ########################
  
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
  
  def delete_cascades?
    return @delete_cascades
  end
  
  ############
  #  cease!  #
  ############
  
  def cease!
    return persistence_port.delete_object!( persistence_id, persistence_bucket )
  end

end

