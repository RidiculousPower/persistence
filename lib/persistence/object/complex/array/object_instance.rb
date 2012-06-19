
module ::Persistence::Object::Complex::Array::ObjectInstance
  
  #############
  #  persist  #
  #############
  
  def persist
    
    persistence_bucket.adapter_bucket.get_object( persistence_id ).each do |this_index, this_value|
      self[ this_index ] = this_value
    end
    
    return self
    
  end
  
end
