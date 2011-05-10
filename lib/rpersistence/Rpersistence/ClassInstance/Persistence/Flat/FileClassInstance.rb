
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

    port, bucket, key                     = parse_persist_args_with_bucket_accessor( args, :instance_persistence_bucket )
    
    global_id                             = port.adapter.get_object_id_for_bucket_and_key( bucket, key )

    persistence_value                     = nil

    if global_id

      # get the class to see if we are persisting path or contents    
      stored_bucket, stored_key, klass       = port.adapter.get_bucket_key_class_for_object_id( global_id )

      if klass == File::Path
      
        persistence_value = File::Path.persist( port, bucket, key )
      
      elsif klass == File::Contents

        persistence_value = File::Contents.persist( port, bucket, key )
      
      end

    end
    
    return persistence_value

  end

end
