
module ::Persistence::Object::Persist::ObjectInstance

  ##############
  #  persist!  #
  ##############

  def persist!
    
    unless persistence_port
      raise ::Persistence::Port::Exceptions::NoPortEnabled, 'No persistence port currently enabled.'
    end
    
    self.persistence_id = persistence_port.put_object!( self )

    return self
    
  end
  
  ################
  #  persisted?  #
  ################

  def persisted?
    return persistence_port.get_bucket_name_for_object_id( persistence_id ) ? true : false
  end
  
end
