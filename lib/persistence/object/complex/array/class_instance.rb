
module ::Persistence::Object::Complex::Array::ClassInstance
  
  #############
  #  persist  #
  #############
  
  def persist( global_id )
    
    object = [ ]
    
    object.persistence_id = global_id

    instance_persistence_bucket.get_object_hash( global_id ).each do |this_key, this_value|
      if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        object.push( this_value.persist )
      else
        object.push( this_value )
      end
    end
    
    return object
    
  end
  
end
