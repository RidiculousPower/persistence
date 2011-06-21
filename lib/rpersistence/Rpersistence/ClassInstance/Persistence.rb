
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Class Objects  ----------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Persistence

  #############################################  Persist  ###################################################

  ###################
  #  Klass.persist  #
  ###################
  
  # * property_name
  # * :bucket, property_name
  # * :port, :bucket, property_name
  def persist( *args )

    index, value, no_value = parse_persist_args_from_port( args )

    if no_value
      
      persistence_value = Rpersistence.default_cursor_class.new( persistence_port, instance_persistence_bucket, index )

    else

      global_persistence_id = persistence_port.adapter.get_object_id_for_bucket_index_and_key( instance_persistence_bucket, index, value )

      object = nil
      if ( global_persistence_id )
        object = object_for_persistence_id( persistence_port, global_persistence_id )
      end
    
    end
    
    return object

  end

  ######################
  #  Klass.persisted?  #
  ######################

  def persisted?( *args )

    index, value, no_value = parse_persist_args_from_port( args, true )

    is_persisted  = ( persistence_port.adapter.persistence_key_exists_for_index?( instance_persistence_bucket, index, value ) ? true : false )      
    
    return is_persisted
    
  end

  ##############################################  Cease  ####################################################

  ##################
  #  Klass.cease!  #
  ##################

  # deletes from storage (archives if appropriate)
  def cease!( *args )

    index, value, no_value = parse_persist_args_from_port( args, true )

    # if we have Class then we are 
    global_persistence_id = persistence_port.adapter.get_object_id_for_bucket_index_and_key( instance_persistence_bucket, index, value )
  
    persistence_port.adapter.delete_object!( global_persistence_id, instance_persistence_bucket )

    indexes.each do |this_index, unique_or_permits_duplicates|
  		persistence_port.adapter.delete_index_for_object( instance_persistence_bucket, this_index, global_persistence_id )
    end
    
    return self
    
  end

end
