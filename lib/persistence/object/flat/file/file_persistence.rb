
module ::Persistence::Object::Flat::File::FilePersistence

  # used for:
  # * File::ObjectInstance
  # * File::ClassInstance
  # * Persistence::Bucket instance
  # * Persistence::Port instance
  # * Persistence
  #
  # looks up configuration chain in that order

  include ::CascadingConfiguration::Setting
  
  extend self

  ################################
  #  persists_files_by_content?  #
  ################################

  attr_setting :persists_files_by_content? => :persist_files_by_content=
  
  #############################
  #  persists_files_by_path?  #
  #############################

  attr_setting :persists_files_by_path? => :persist_files_by_path=

  #####################################
  #  persists_file_paths_as_objects?  #
  #####################################

  attr_setting :persists_file_paths_as_objects? => :persist_file_paths_as_objects=

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  attr_setting :persists_file_paths_as_strings? => :persist_file_paths_as_strings=

  ############################
  #  persist_files_by_path!  #
  ############################

  def persist_files_by_path!
    
    self.persist_files_by_path = true
    self.persist_files_by_content = false

    return self

  end
  
  ###############################
  #  persist_files_by_content!  #
  ###############################

  def persist_files_by_content!

    self.persist_files_by_content = true
    self.persist_files_by_path = false

    return self

  end

  alias_method( :persists_files_by_content!, :persist_files_by_content! )

  ####################################
  #  persist_file_paths_as_objects!  #
  ####################################

  def persist_file_paths_as_objects!

    self.persist_file_paths_as_objects = true
    self.persist_file_paths_as_strings = false

    return self

  end

  alias_method( :persists_file_paths_as_objects!, :persist_file_paths_as_objects! )

  ####################################
  #  persist_file_paths_as_strings!  #
  ####################################

  def persist_file_paths_as_strings!

    self.persist_file_paths_as_strings = true
    self.persist_file_paths_as_objects = false

    return self

  end
    
  alias_method( :persists_file_paths_as_strings!, :persist_file_paths_as_strings! )
  
end
