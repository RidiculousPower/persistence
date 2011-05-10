
module Rpersistence::ClassInstance::Persistence::Flat

  #############
  #  persist  #
  #############
  
  # * property_name
  # * :bucket, property_name
  # * :port, :bucket, property_name
  def persist( *args )

    port, bucket, key                     = parse_persist_args_with_bucket_accessor( args, :instance_persistence_bucket )

    global_id                             = port.adapter.get_object_id_for_bucket_and_key( bucket, key )
    
    persistence_value                     = nil

    if global_id

      persistence_value_hash              = port.adapter.get_object( global_id, bucket )

      if persistence_value_hash
        persistence_value_key_data        = persistence_value_hash.first
				if persistence_value_key_data
					persistence_value                 = persistence_value_key_data[ 1 ]
        	persistence_value.persistence_id  = global_id
				end
				
      end
      
    end
    
    return persistence_value

  end

end
