
module ::Persistence::Object::Cease::ObjectInstance

  ############
  #  cease!  #
  ############

  def cease!
    
    persistence_port.delete_object!( persistence_id )
    
    self.persistence_id = nil
    
    return self

  end
  
end
