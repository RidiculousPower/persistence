
###
# Cursor subclass that automatically performs atomic lookups on attributes. 
#
module ::Persistence::Cursor::Atomic

  ################
  #  get_object  #
  ################

  ###
  # Get object for persistence ID using atomic attribute loading, regardless how attributes are declared.
  #
  # @param global_id Persistence ID to retrieve object.
  #
  # @return [Object] Object being retrieved for persistence ID.
  #
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
