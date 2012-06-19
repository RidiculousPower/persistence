
module ::Persistence::Port::FilePersistence::PortInstance

  # should be loaded _after_ FilePersistence
  # ensures that class looks up first at class level then to bucket then to port for default
  include ::Persistence::Port::FilePersistence

  ############################
  #  persists_file_by_path?  #
  ############################

  def persists_file_by_path?

    return ( persists_file_by_path ? true : false )
    
  end

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  def persists_file_paths_as_strings?

    return ( persists_file_paths_as_objects ? false : true )

  end

  #####################################
  #  persists_file_paths_as_objects?  #
  #####################################

  def persists_file_paths_as_objects?

    return ( persists_file_paths_as_objects ? true : false )

  end

end
