
###
# Common module used for look-up chain for file persistence configuration.
#   Lookup chain is: File instance, File class, Persistence::Port::Bucket instance, Persistence::Port instance,
#   Persistence singleton.
#
module ::Persistence::Object::Flat::File::FilePersistence

  include ::CascadingConfiguration::Setting
  
  extend self

  ################################
  #  persists_files_by_content?  #
  ################################

  ###
  #
  # @method persists_files_by_content?
  #
  # Query whether File instances should be persisted by content (rather than by path).
  #   Lookup chain is: File instance, File class, Persistence::Port::Bucket instance, Persistence::Port instance,
  #   Persistence singleton.
  #
  # @return [true,false] Whether files should be persisted by content rather than by path.
  #
  attr_setting :persists_files_by_content? => :persist_files_by_content=
  
  #############################
  #  persists_files_by_path?  #
  #############################

  ###
  #
  # @method persists_files_by_path?
  #
  # Query whether File instances should be persisted by path (rather than by content).
  #   Lookup chain is: File instance, File class, Persistence::Port::Bucket instance, Persistence::Port instance,
  #   Persistence singleton.
  #
  # @return [true,false] Whether files should be persisted by path rather than by content.
  #
  attr_setting :persists_files_by_path? => :persist_files_by_path=

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  ###
  #
  # @method persists_file_paths_as_strings?
  #
  # Query whether File paths should be persisted as strings (rather than by objects).
  #   Lookup chain is: File instance, File class, Persistence::Port::Bucket instance, Persistence::Port instance,
  #   Persistence singleton.
  #
  # @return [true,false] Whether files should be persisted as strings rather than as objects.
  #
  attr_setting :persists_file_paths_as_strings? => :persist_file_paths_as_strings=

  ############################
  #  persist_files_by_path!  #
  ############################
  
  ###
  # Declare that files should be persisted by path (rather than by contents).
  #
  def persist_files_by_path!
    
    self.persist_files_by_path = true
    self.persist_files_by_content = false

    return self

  end
  
  ###############################
  #  persist_files_by_content!  #
  ###############################

  ###
  # Declare that files should be persisted by contents (rather than by path).
  #
  def persist_files_by_content!

    self.persist_files_by_content = true
    self.persist_files_by_path = false

    return self

  end

  alias_method( :persists_files_by_content!, :persist_files_by_content! )
  
end
