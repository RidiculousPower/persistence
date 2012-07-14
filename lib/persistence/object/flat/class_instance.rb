
###
# Class methods for flat objects enabled with persistence capabilities.
#
module ::Persistence::Object::Flat::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( *args )

    persistence_value = nil

    index_instance, key, no_key = parse_class_args_for_index_value_no_value( args )

    # if no key, open a cursor for a list
    if no_key

      persistence_value = ::Persistence::Cursor.new( instance_persistence_bucket, index_instance )

    else

      global_id = index_instance ? index_instance.get_object_id( key ) : key
      
      persistence_value = instance_persistence_bucket.get_flat_object( global_id )

    end
    
    return persistence_value

  end

end
