module Rpersistence::Instance::Equals

  #########
  #   ==  # 
  #########

  # we overload :== so that we can compare users after load to before load
  # if we don't do this then we have rpersistence internal vars in one and not the other
  def ==( other_object )

    objects_are_equal = true
    
    non_rpersistence_ivars                = persistence_hash_for_current_state
    other_object_non_rpersistence_ivars   = other_object.persistence_hash_for_current_state
    
    # if either object have non_atomic vars set, we need to use those values to compare instead of persisted values
    
    self_empty  = non_rpersistence_ivars.empty?
    other_empty = other_object_non_rpersistence_ivars.empty?
  
    if  self.class != other_object.class  or
        ( self_empty and ! other_empty )  or
        ( other_empty and ! self_empty )

      objects_are_equal = false
      
    else
            
      non_rpersistence_ivars.each do |property_name, property_value|

			  objects_are_equal = ( property_value == other_object_non_rpersistence_ivars[ property_name ] )

			  break unless objects_are_equal

      end
       
    end

    return objects_are_equal
    
  end
  
end
