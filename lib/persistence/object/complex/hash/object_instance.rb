
module ::Persistence::Object::Complex::Hash::ObjectInstance
    
  #############
  #  persist  #
  #############
  
  def persist
    
    port_hash = persistence_bucket.adapter_bucket.get_object( persistence_id )

    replace( port_hash )

    self.each do |this_key, this_value|
      if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject )
        self[ this_key ] = this_value.persist
      else
        self[ this_key ] = this_value
      end
    end
    
    return self
    
  end
  
end
