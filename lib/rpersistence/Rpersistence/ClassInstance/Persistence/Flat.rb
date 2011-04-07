
module Rpersistence::ClassInstance::Persistence::Flat

  #############
  #  persist  #
  #############
  
	# * property_name
	# * :bucket, property_name
	# * :port, :bucket, property_name
  def persist( *args )

    @__rpersistence__persisting_from_port__ = true

		port, bucket, key                     = parse_persist_args( args )
		
		global_id                             = port.adapter.get_object_id_for_bucket_and_key( bucket, key )
    persistence_value                     = nil
    
    if global_id

      persistence_value_hash              = port.adapter.get_object( global_id, bucket )

      if persistence_value_hash

        persistence_value                 = persistence_value_hash[ nil ]

        persistence_value.persistence_id  = global_id

      end
      
    end
    
    remove_instance_variable( :@__rpersistence__persisting_from_port__ )

    return persistence_value

  end

end
