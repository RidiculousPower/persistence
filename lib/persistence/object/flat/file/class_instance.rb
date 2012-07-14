
###
# Class methods for File objects enabled with persistence capabilities.
#
module ::Persistence::Object::Flat::File::ClassInstance

  include ::Persistence::Object::Flat::File::FilePersistence
  
  #############
  #  persist  #
  #############
  
  def persist( *args )

    persistence_value = nil

    index_instance, key, no_key = parse_class_args_for_index_value_no_value( args )

    # if no key, open a cursor for a list
    if no_key

      persistence_value = ::Persistence::Cursor.new( instance_persistence_bucket, index_instance )

    else

      if global_id = index_instance ? index_instance.get_object_id( key ) : key
      
        persistence_value_hash = instance_persistence_bucket.get_object_hash( global_id )
      
        persistence_value = persistence_value_hash.first[ 1 ]
      
        if persistence_value.is_a?( ::Persistence::Object::Flat::File::Path ) and
           ! persists_file_paths_as_strings?

          persistence_value = open( persistence_value, persistence_value.mode || 'r' )

        end

      end
      
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

  ###
  # Query whether File instances should be persisted by path (rather than by content).
  #   Lookup chain is: File instance, File class, Persistence::Port::Bucket instance, Persistence::Port instance,
  #   Persistence singleton.
  #
  # @return [true,false] Whether files should be persisted by path rather than by content.
  #
  def persists_files_by_path?
    
    persists_files_by_path = nil
    
    persists_files_by_path = super
    
    if persists_files_by_path.nil?
      persists_files_by_path = instance_persistence_bucket.persists_files_by_path?
    end
    
    return persists_files_by_path
    
  end

  #####################################
  #  persists_file_paths_as_strings?  #
  #####################################

  ###
  # Query whether File paths should be persisted as strings (rather than by objects).
  #   Lookup chain is: File instance, File class, Persistence::Port::Bucket instance, Persistence::Port instance,
  #   Persistence singleton.
  #
  # @return [true,false] Whether files should be persisted as strings rather than as objects.
  #
  def persists_file_paths_as_strings?
    
    persists_file_paths_as_strings = nil
    
    persists_file_paths_as_strings = super
    
    if persists_file_paths_as_strings.nil?
      persists_file_paths_as_strings = instance_persistence_bucket.persists_file_paths_as_strings?
    end
    
    return persists_file_paths_as_strings
    
  end

end
