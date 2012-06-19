
module ::Persistence::Cursor::Atomic

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  def get_object( global_id )
    
    klass = @persistence_bucket.parent_port.get_class_for_object_id( global_id )
    
    object = nil
    
    if klass
      object = klass.new
      object.persistence_id = global_id
      object.attrs_atomic!
    end
    
    return object

  end

end
