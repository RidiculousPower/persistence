
###
# Class methods for array objects enabled with persistence capabilities.
#
module ::Persistence::Object::Complex::Array::ClassInstance
  
  #############
  #  persist  #
  #############
  
  def persist( *args )
    
    index, key, no_key = parse_class_args_for_index_value_no_value( args, true )
    
    if index
      global_id = index.get_object_id( key )
    else
      global_id = key
    end
    
    object = new
    
    object.persistence_id = global_id

    instance_persistence_bucket.get_object_hash( global_id ).each do |this_key, this_value|
      if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        object.push( this_value.persist )
      else
        object.push( this_value )
      end
    end
    
    return object
    
  end
  
end
