
module ::Persistence::Object::Cease::ClassInstance

  ############
  #  cease!  #
  ############

  def cease!( global_id )
    
    return instance_persistence_port.delete_object!( global_id )
    
  end
  
end
