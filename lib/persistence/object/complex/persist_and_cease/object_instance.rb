
module ::Persistence::Object::Complex::PersistAndCease::ObjectInstance

  #############
  #  persist  #
  #############
  
  def persist

    persistence_hash_from_port = persistence_bucket.get_object_hash( persistence_id )
    load_persistence_hash( persistence_port, persistence_hash_from_port )
    
    return self

  end

  ############
  #  cease!  #
  ############

  def cease!
    
    global_id = persistence_id
    
    if persistence_hash_in_port = persistence_bucket.delete_object!( global_id )

      persistence_hash_in_port.each do |this_attribute, this_value|

        if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject ) and 
           this_value.delete_cascades?

          this_value.cease!

        end

      end

    end
    
    return self
    
  end

end
