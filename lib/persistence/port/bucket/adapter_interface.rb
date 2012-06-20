
module ::Persistence::Port::Bucket::AdapterInterface

  ####################
  #  adapter_bucket  #
  ####################
  
  def adapter_bucket
    
    unless @adapter_bucket
      raise 'Persistence port must be enabled first.'
    end
    
    return @adapter_bucket
    
  end

  #################
  #  put_object!  #
  #################

  def put_object!( object )    

    return adapter_bucket.put_object!( object )

  end

  ###########
  #  count  #
  ###########

  def count 

    return adapter_bucket.count

  end
    
  ################
  #  get_object  #
  ################

  def get_object( global_id )
    
    object = nil
    
    # get the class
    if klass = @parent_port.get_class_for_object_id( global_id )

      object = klass.new
      
      object.persistence_id = global_id

      # if we have non-atomic attributes, load them
      unless klass.non_atomic_attribute_readers.empty?

        if persistence_hash_from_port = get_object_hash( global_id )
          
          object.load_persistence_hash( object.persistence_port, persistence_hash_from_port )

        end

      end

    end
    
    return object

  end
  
  #####################
  #  get_object_hash  #
  #####################

  def get_object_hash( global_id )

    return adapter_bucket.get_object( global_id )

  end

  #####################
  #  get_flat_object  #
  #####################

  def get_flat_object( global_id )

    flat_object = nil

    if persistence_value_hash = adapter_bucket.get_object( global_id )

      if persistence_value_key_data = persistence_value_hash.first
        flat_object = persistence_value_key_data[ 1 ]
        flat_object.persistence_id = global_id
      end
    end

    return flat_object
    
  end

  ####################
  #  delete_object!  #
  ####################

  def delete_object!( global_id )
    
    return adapter_bucket.delete_object!( global_id )
  
  end

  ###################
  #  get_attribute  #
  ###################

  def get_attribute( object, attribute_name )

    primary_key = primary_key_for_attribute_name( object, attribute_name )

    return adapter_bucket.get_attribute( object, primary_key )

  end

  ####################
  #  put_attribute!  #
  ####################
  
  def put_attribute!( object, attribute_name, attribute_value )
    
    primary_key = primary_key_for_attribute_name( object, attribute_name )
    
    return adapter_bucket.put_attribute!( object, primary_key, attribute_value )
    
  end

  #######################
  #  delete_attribute!  #
  #######################

  def delete_attribute!( object, attribute_name )

    primary_key = primary_key_for_attribute_name( object, attribute_name )

    return adapter_bucket.delete_attribute!( object, primary_key )

  end

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  def primary_key_for_attribute_name( object, attribute_name )

    return adapter_bucket.primary_key_for_attribute_name( object, attribute_name )

  end
    
end
