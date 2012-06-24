
module ::Persistence::Object::Flat::File::ClassInstance

  include ::Persistence::Object::Flat::File::FilePersistence
  
  #############
  #  persist  #
  #############
  
  def persist( *args )

    persistence_value = super

    if persists_file_paths_as_objects?  and 
       persistence_value.is_a?( ::Persistence::Object::Flat::File::Path )

      persistence_value = File.open( persistence_value, 
                                     persistence_value.mode || 'r' )

    end
    
    return persistence_value

  end

  ################################
  #  persists_files_by_content?  #
  ################################

  def persists_files_by_content?
    
    persists_files_by_content = nil
    
    persists_files_by_content = super
    
    if persists_files_by_content.nil?
      persists_files_by_content = instance_persistence_bucket.persists_files_by_content?
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
      persists_files_by_path = instance_persistence_bucket.persists_files_by_path?
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
      persists_file_paths_as_objects = instance_persistence_bucket.persists_file_paths_as_objects?
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
      persists_file_paths_as_strings = instance_persistence_bucket.persists_file_paths_as_strings?
    end
    
    return persists_file_paths_as_strings
    
  end

end
