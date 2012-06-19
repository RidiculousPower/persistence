
module ::Persistence::Object::Complex::Hash::ClassInstance

  #############
  #  persist  #
  #############
  
  def persist( global_id )
    
    hash_from_port = instance_persistence_bucket.get_object_hash( global_id )
    
    object = { }
    
    object.persistence_id = global_id

    hash_from_port.each do |this_key, this_value|
      if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        this_value = this_value.persist
        object[ this_key ] = this_value
      else
        object[ this_key ] = this_value
      end
    end
    
    return object
    
  end
  
end
