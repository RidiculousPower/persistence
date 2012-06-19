
module ::Persistence::Object::Complex::Cease::ObjectInstance

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
