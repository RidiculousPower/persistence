
module ::Persistence::Port::FilePersistence

  # used for ObjectInstance, ClassInstance, Port instance, Bucket instance
  # looks up configuration chain in that order

  include ::CascadingConfiguration::Setting

  ##########################
  #  persist_file_by_path  #
  ##########################

  def persist_file_by_path
    self.persists_file_by_path = true
    return self
  end

  #############################
  #  persist_file_by_content  #
  #############################

  def persist_file_by_content
    self.persists_file_by_path = false
    return self
  end

  ############################
  #  persists_file_by_path?  #
  ############################

  def persists_file_by_path?
    return ( ( persists_file_by_path == nil ) ? self.class.persists_file_by_path? : persists_file_by_path )
  end

  ###################################
  #  persist_file_paths_as_objects  #
  ###################################

  def persist_file_paths_as_objects
    self.persists_file_paths_as_objects = true
    return self
  end

  ###################################
  #  persist_file_paths_as_strings  #
  ###################################

  def persist_file_paths_as_strings
    self.persists_file_paths_as_objects = false
    return self
  end
  
  #####################################
  #  persists_file_paths_as_objects?  #
  #####################################

  # do we want to retrieve file paths as file objects pointing to path?
  def persists_file_paths_as_objects?
    return ( ( persists_file_paths_as_objects == nil ) ? self.class.persists_file_paths_as_objects? : persists_file_paths_as_objects )
  end

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  # do we want to retrieve file paths as path strings?
  def persists_file_paths_as_strings?
    return ( ( persists_file_paths_as_objects == nil ) ? self.class.persists_file_paths_as_strings? : ! persists_file_paths_as_objects )
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################
  
  attr_configuration :persists_file_by_path, :persists_file_paths_as_objects

end
