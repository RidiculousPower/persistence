
###
# @private
#
# Internal helper for parsing args of the format: method, method( global_id ), method( index_name, value ),
#   method( index_instance, value ), method( index_name => value ), method( index_instance => value ).
#
module ::Persistence::Object::ParsePersistenceArgs

  ######################
  #  process_file_key  #
  ######################
  
  ###
  # Internal helper method to handle instances of File as key.
  #
  # @param file_key [File] File instance to process as key.
  #
  # @return [Persistence::Object::Flat::File::Path,Persistence::Object::Flat::File::Contents] Processed key.
  #
  def process_file_key( file_key )

    # do we have a file key? if so we need to replace it with File::Path or File::Contents

    processed_key = nil
    
    if file_key.persists_files_by_path?
      processed_key = ::Persistence::Object::Flat::File::Path.new( file_key.path )
    else
      starting_pos  = file_key.pos
      processed_key = ::Persistence::Object::Flat::File::Contents.new( file_key.readlines.join )
      file_key.pos  = starting_pos
    end
    
    return processed_key
    
  end
    
end
