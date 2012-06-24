
module ::Persistence::Object::Complex::Hash::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( *args )
    
    index, key, no_key = parse_args_for_index_value_no_value( args, true )
    
    if index
      global_id = index.get_object_id( key )
    else
      global_id = key
    end
    
    object = { }
    
    object.persistence_id = global_id

    hash_from_port = instance_persistence_bucket.get_object_hash( global_id )

    hash_from_port.each do |this_key, this_value|
      if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        this_value = this_value.persist
        object[ this_key ] = this_value
      else
        object[ this_key ] = this_value
      end
    end
    
    return object
    
  end
  
end
