
module ::Persistence::Object::Flat::File::ObjectInstance

  include ::Persistence::Object::Flat::File::FilePersistence

  ##############
  #  persist!  #
  ##############

  def persist!( *args )
    
    starting_pos = self.pos
    
    # if we are persisting by file path
    persistence_instance = nil
    if persists_files_by_path?
      persistence_instance = ::Persistence::Object::Flat::File::Path.new( path )
    # if we are persisting by file contents
    else
      persistence_instance = ::Persistence::Object::Flat::File::Contents.new( self.readlines.join )
    end

    persistence_instance.persistence_port   = persistence_port
    persistence_instance.persistence_bucket = persistence_bucket
    
    # set new instance ID to current ID
    persistence_instance.persistence_id = persistence_id
    
    persistence_instance.persist!( *args )

    # if we got ID from persist! on our instance set our own ID to it
    self.persistence_id = persistence_instance.persistence_id

    # rewind file to wherever we started
    self.pos = starting_pos

    return self
  
  end

  ################################
  #  persists_files_by_content?  #
  ################################

  def persists_files_by_content?
    
    persists_files_by_content = nil
    
    persists_files_by_content = super
    
    if persists_files_by_content.nil?
      persists_files_by_content = self.class.persists_files_by_content?
    end
    
    return persists_files_by_content
    
  end

  #############################
  #  persists_files_by_path?  #
  #############################

  def persists_files_by_path?
    
    persists_files_by_path = nil
    
    persists_files_by_path = super
    
    if persists_files_by_path.nil?
      persists_files_by_path = self.class.persists_files_by_path?
    end
    
    return persists_files_by_path
    
  end

  #####################################
  #  persists_file_paths_as_objects?  #
  #####################################

  def persists_file_paths_as_objects?
    
    persists_file_paths_as_objects = nil
    
    persists_file_paths_as_objects = super
    
    if persists_file_paths_as_objects.nil?
      persists_file_paths_as_objects = self.class.persists_file_paths_as_objects?
    end
    
    return persists_file_paths_as_objects
    
  end

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  def persists_file_paths_as_strings?
    
    persists_file_paths_as_strings = nil
    
    persists_file_paths_as_strings = super
    
    if persists_file_paths_as_strings.nil?
      persists_file_paths_as_strings = self.class.persists_file_paths_as_strings?
    end
    
    return persists_file_paths_as_strings
    
  end

end
