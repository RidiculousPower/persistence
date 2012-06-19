
module ::Persistence::Object::Flat::File::ObjectInstance

  ##############
  #  persist!  #
  ##############

  def persist!
    
    starting_pos = self.pos
    
    # if we are persisting by file path
    persistence_instance = nil
    if persistence_port.persists_file_by_path?
      persistence_instance = ::Persistence::Object::Flat::File::Path.new( path )
    # if we are persisting by file contents
    else
      persistence_instance = ::Persistence::Object::Flat::File::Contents.new( self.readlines.join )
    end

    persistence_instance.persistence_port   = persistence_port
    persistence_instance.persistence_bucket = persistence_bucket
    
    # set new instance ID to current ID
    persistence_instance.persistence_id = persistence_id
    
    persistence_instance.persist!

    # if we got ID from persist! on our instance set our own ID to it
    self.persistence_id = persistence_instance.persistence_id

    # rewind file to wherever we started
    self.pos = starting_pos

    return self
  
  end

end
