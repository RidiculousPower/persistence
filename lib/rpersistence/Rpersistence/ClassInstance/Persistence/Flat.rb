
module Rpersistence::ClassInstance::Persistence::Flat

  include Rpersistence::ClassInstance::Persistence::Flat::ParsePersistenceArgs

  #############
  #  persist  #
  #############
  
  # * property_name
  # * :bucket, property_name
  # * :port, :bucket, property_name
  def persist( *args )

    key, no_key = parse_flat_persist_args_from_port( args )

    persistence_value = nil

    if no_key
      
      persistence_value = Rpersistence.default_cursor_class.new( persistence_port, instance_persistence_bucket, nil )

    else
      
      global_id = persistence_port.adapter.get_object_id_for_bucket_index_and_key( instance_persistence_bucket, :persistence_key, key )

      if global_id

        persistence_value_hash              = persistence_port.adapter.get_object( global_id, instance_persistence_bucket )

        if persistence_value_hash
          persistence_value_key_data        = persistence_value_hash.first
  				if persistence_value_key_data
  					persistence_value                 = persistence_value_key_data[ 1 ]
          	persistence_value.persistence_id  = global_id
  				end
				
        end
      
      end
    
    end
    
    return persistence_value

  end

  ######################
  #  Klass.persisted?  #
  ######################

  def persisted?( *args )

    key, no_key = parse_flat_persist_args_from_port( args, true )

    return super( :persistence_key, key )

  end
  
  ##################
  #  Klass.cease!  #
  ##################

  # deletes from storage (archives if appropriate)
  def cease!( *args )
  
    key, no_key = parse_flat_persist_args_from_port( args, true )

    return super( :persistence_key, key )
  
  end
  
end
