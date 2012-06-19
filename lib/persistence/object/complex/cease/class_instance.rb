
module ::Persistence::Object::Complex::Cease::ClassInstance

  ############
  #  cease!  #
  ############

  def cease!( global_id )

    if persistence_hash_in_port = instance_persistence_bucket.delete_object!( global_id )

      persistence_hash_in_port.each do |this_attribute, this_value|

        if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject ) and 
           delete_cascades?( global_id, this_value.persistence_id )

          this_value.cease!

        end

      end

    end
    
    return instance_persistence_port.delete_object!( global_id )
    
  end
  
end
