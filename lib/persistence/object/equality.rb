
module ::Persistence::Object::Equality

  ########
  #  ==  # 
  ########

  # we overload :== so that we can compare users after load to before load
  # if we don't do this then we have persistence internal vars in one and not the other
  def ==( other_object )

    objects_are_equal = false
    
    # if we have the same ruby instance
    if super( other_object )
      
      objects_are_equal = true
    
    # or if both classes are the same and the ids are the same
    elsif self.class == other_object.class                and
          other_object.respond_to?( :persistence_id )     and 
          persistence_id == other_object.persistence_id

          objects_are_equal = true

    end

    return objects_are_equal
    
  end


end
