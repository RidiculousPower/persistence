
#---------------------------------------------------------------------------------------------------------#
#---------------------------------------  File Class Instance  -------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ClassInstance::Persistence::Flat::FileClassInstance

  #############
  #  persist  #
  #############
  
  # * property_name
  # * :bucket, property_name
  # * :port, :bucket, property_name
  def persist( *args )

    key, no_key = parse_flat_persist_args_from_port( args )

    persistence_value  = nil
    
    if no_key
      
      persistence_value = Rpersistence.default_cursor_class.new( persistence_port, instance_persistence_bucket, nil )
      
    else
      
      global_id = persistence_port.adapter.get_object_id_for_bucket_index_and_key( instance_persistence_bucket, :persistence_key, key )                       

      if global_id

        # get the class to see if we are persisting path or contents    
        klass = persistence_port.adapter.get_class_for_object_id( global_id )

        prior_bucket                      = klass.instance_persistence_bucket
        prior_port                        = klass.persistence_port
        klass.instance_persistence_bucket = instance_persistence_bucket
        klass.persistence_port            = persistence_port
        
        persistence_value                 = klass.persist( key )

        klass.instance_persistence_bucket = prior_bucket
        klass.persistence_port            = prior_port

      end
    
    end
    
    return persistence_value

  end

end
