
module Rpersistence::Instance::Variables

  #########
  #   ==  # 
  #########

  # we overload :== so that we can compare users after load to before load
  # if we don't do this then we have rpersistence internal vars in one and not the other
  def ==( other_object )

    objects_are_equal = true

    # if we have the same ruby instance
    if super( other_object )
      
      objects_are_equal = true
    
    # or if we have an id for both objects and the ids are not the same
    elsif persistence_id and other_object.persistence_id and persistence_id != other_object.persistence_id

      objects_are_equal = false

    # or if the classes are not the same
    elsif  self.class != other_object.class

      objects_are_equal = false
      
    # otherwise if we have instance variables, compare
    elsif respond_to?( :instance_variables ) and other_object.respond_to?( :instance_variables ) and other_object.respond_to?( :instance_variables_hash )

      objects_are_equal = ( instance_variables_hash == other_object.instance_variables_hash )
      
    # if we don't have ivars then we use super's result, true or false
    else
      
      objects_are_equal = super( other_object )
      
    end

    return objects_are_equal
    
  end


end
