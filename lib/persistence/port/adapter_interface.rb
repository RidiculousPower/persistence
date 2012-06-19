
module ::Persistence::Port::AdapterInterface

  #############
  #  adapter  #
  #############
  
  def adapter
    
    raise 'Persistence port must be enabled first.' unless @adapter
    
    return @adapter
    
  end

  ###################################
  #  get_bucket_name_for_object_id  #
  ###################################
  
  def get_bucket_name_for_object_id( global_id )
    return adapter.get_bucket_name_for_object_id( global_id )
  end

  #############################
  #  get_class_for_object_id  #
  #############################
  
  def get_class_for_object_id( global_id )
    return adapter.get_class_for_object_id( global_id )
  end

  #################
  #  put_object!  #
  #################

  def put_object!( object )    

    return object.persistence_bucket.put_object!( object )

  end

  ####################
  #  delete_object!  #
  ####################

  def delete_object!( global_id )
  
    bucket = get_bucket_name_for_object_id( global_id )
    
    persistence_bucket( bucket ).delete_object!( global_id ) if bucket
  
    return self
    
  end
  
  ################
  #  get_object  #
  ################

  def get_object( global_id )
        
    object = nil
        
    bucket = get_bucket_name_for_object_id( global_id )
    
    if bucket
      object = persistence_bucket( bucket ).get_object( global_id )
    end

    return object
    
  end

  #####################
  #  get_flat_object  #
  #####################

  def get_flat_object( global_id )
    
    flat_object = nil
    
    bucket = get_bucket_name_for_object_id( global_id )

    if bucket
      flat_object = persistence_bucket( bucket ).get_flat_object( global_id )
    end
    
    return flat_object
    
  end
  
end
