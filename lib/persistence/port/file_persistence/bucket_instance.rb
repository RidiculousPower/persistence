
module ::Persistence::Port::FilePersistence::BucketInstance

  # should be loaded _after_ FilePersistence
  # ensures that class looks up first at class level then to bucket then to port for default
  include ::Persistence::Port::FilePersistence

  ############################
  #  persists_file_by_path?  #
  ############################

  def persists_file_by_path?

    if ( should_persists_file_by_path = persists_file_by_path ) == nil
      should_persists_file_by_path = persistence_port.persists_file_by_path?
    end
    
    return should_persists_file_by_path
    
  end

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  def persists_file_paths_as_strings?

    if ( should_persists_file_paths_as_strings = persists_file_paths_as_strings ) == nil
      should_persists_file_paths_as_strings = persistence_port.persists_file_paths_as_strings?
    end
    
    return should_persists_file_paths_as_strings

  end

  #####################################
  #  persists_file_paths_as_objects?  #
  #####################################

  def persists_file_paths_as_objects?

    if ( should_persists_file_paths_as_objects = persists_file_paths_as_objects ) == nil
      should_persists_file_paths_as_objects = persistence_port.persists_file_paths_as_objects?
    end
    
    return should_persists_file_paths_as_objects

  end

end
