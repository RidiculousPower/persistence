
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  File Instances  ---------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Persistence::Flat::FileInstance

  ##############
  #  persist!  #
  ##############

  # * property_name
  # * :bucket, property_name
  # * :port, :bucket, property_name
  def persist!( *args )
    
    port, bucket, key = parse_persist_args_with_bucket_accessor( args, :persistence_bucket )
    
    starting_pos = self.pos
    
    # if we are persisting by file path
    if port.persists_file_by_path?
      
      # get path and save as File::Path
      file_path = File::Path.new( path )
      
      file_path.persist!( port, bucket, key )
      
    # if we are persisting by file contents
    else

      # get contents and save as File::Contents
      file_contents = File::Contents.new( self.readlines.join )

      file_contents.persist!( port, bucket, key )
      
    end

    # rewind file to wherever we started
    self.pos = starting_pos
        
    # return the object we're persisting
    return self
  
  end

end
