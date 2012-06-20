
module ::Persistence::Object::Complex::Equality

  include ::Persistence::Object::Equality

  ########
  #  ==  # 
  ########

  # we overload :== so that we can compare users after load to before load
  # if we don't do this then we have persistence internal vars in one and not the other
  def ==( other_object )

    objects_are_equal = false
    
    # if we have the same ruby instance
    # and if both classes are the same and the ids are the same
    if super( other_object )

      # test non-atomic attributes for equality
      if objects_are_equal = non_atomic_attribute_readers.empty? or 
         objects_are_equal = ( persistence_hash_to_port == other_object.persistence_hash_to_port )

        # test atomic attributes for equality
        unless atomic_attribute_readers.empty?

          atomic_attribute_readers.each do |this_attribute|
            this_value = __send__( this_attribute )
            this_other_value = other_object.__send__( this_attribute )
            break unless objects_are_equal = ( this_value == this_other_value )
          end
          
        end
        
      end

    end

    return objects_are_equal
    
  end


end
