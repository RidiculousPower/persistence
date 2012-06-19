
module ::Persistence::Object::Flat::File::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( persistence_id )

    persistence_value = super

    if instance_persistence_port.persists_file_paths_as_objects?  and 
       persistence_value.is_a?( ::Persistence::Object::Flat::File::Path )

      persistence_value = File.open( persistence_value, 
                                     persistence_value.mode || 'r' )

    end
    
    return persistence_value

  end

end
