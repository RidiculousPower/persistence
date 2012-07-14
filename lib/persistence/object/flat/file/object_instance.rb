
###
# Instance methods for File objects enabled with persistence capabilities.
#
module ::Persistence::Object::Flat::File::ObjectInstance

  include ::Persistence::Object::Flat::File::FilePersistence

  ##############################
  #  persistence_hash_to_port  #
  ##############################
  
  ###
  # @private
  #
  # Generate hash representing object.
  #
  # @return [Hash] Hash representing information to reproduce object instance.
  #
  def persistence_hash_to_port

    persistence_contents = nil

    # if we are persisting by file path
    if persists_files_by_path?
      persistence_contents = ::Persistence::Object::Flat::File::Path.new( path )
    # if we are persisting by file contents
    else
      starting_pos = self.pos
      persistence_contents = ::Persistence::Object::Flat::File::Contents.new( self.readlines.join )
      # rewind file to wherever we started
      self.pos = starting_pos
    end

    primary_key = persistence_bucket.primary_key_for_attribute_name( self, self.class.to_s )

    return { primary_key => persistence_contents }

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
