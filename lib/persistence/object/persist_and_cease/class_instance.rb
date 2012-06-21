
module ::Persistence::Object::PersistAndCease::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( global_id )

    return instance_persistence_port.get_object( global_id )

  end

  ################
  #  persisted?  #
  ################

  def persisted?( global_id )
    
    return instance_persistence_port.get_bucket_name_for_object_id( global_id ) ? true : false
  
  end

  ###########
  #  count  #
  ###########

  def count
    
    return instance_persistence_bucket.count
    
  end

  ############
  #  cease!  #
  ############
  
  ###
  # Remove object properties stored for object ID from persistence bucket and indexes.
  #
  # @param global_id Object persistence ID.
  #
  def cease!( global_id )
    
    return instance_persistence_port.delete_object!( global_id )
    
  end

end
