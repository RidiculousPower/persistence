
module ::Persistence::Object::Indexing::Persist::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( *args )

    persistence_value = nil

    index_instance, key, no_key = parse_args_for_index_value_no_value( args )
    
    # if no key, open a cursor for a list
    if no_key

      persistence_value = ::Persistence::Cursor.new( instance_persistence_bucket, index_instance )

    else

      global_id = nil
      if index_instance
        global_id = index_instance.get_object_id( key )
      else
        global_id = key
      end

      persistence_value = super( global_id )

    end
    
    return persistence_value
    
  end

  ################
  #  persisted?  #
  ################

  def persisted?( *args )
    
    index_instance, key, no_key = parse_args_for_index_value_no_value( args )
    
    if no_key
      raise ::Persistence::Object::Indexing::Exceptions::KeyValueRequired,
            'Key required when specifying index for :persist!'
    end
    
    global_id = nil
    if index_instance
      global_id = index_instance.get_object_id( key )
    else
      global_id = key
    end

    return super( global_id )
  
  end

  ###########
  #  count  #
  ###########

  def count( index_name = nil )
    
    return_value = 0
    
    if index_name
      return_value = index( index_name ).count
    else
      return_value = instance_persistence_bucket.count
    end
    
    return return_value
    
  end
    
end
