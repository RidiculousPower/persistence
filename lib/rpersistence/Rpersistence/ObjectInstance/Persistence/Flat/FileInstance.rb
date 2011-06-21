
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
  def persist!( key )

    self.persistence_key = key
    
    starting_pos = self.pos
    
    # if we are persisting by file path
    persistence_instance = nil
    if persistence_port.persists_file_by_path?
      persistence_instance = File::Path.new( path )
    # if we are persisting by file contents
    else
      persistence_instance = File::Contents.new( self.readlines.join )
    end

    persistence_instance.persistence_port   = persistence_port
    persistence_instance.persistence_bucket = persistence_bucket

    persistence_instance.persist!( key )

    # rewind file to wherever we started
    self.pos = starting_pos
        
    # return the object we're persisting
    return self
  
  end

end
