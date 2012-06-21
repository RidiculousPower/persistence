
module ::Persistence::Object::Complex::PersistAndCease::Cascades

  include ::CascadingConfiguration::Hash

  attr_configuration_hash :delete_cascades
  
  ##########################
  #  attr_delete_cascades  #
  ##########################

  def attr_delete_cascades( *attributes )
    
    attributes.each do |this_attribute|
      delete_cascades[ this_attribute.accessor_name ] = true
    end
    
    return self
    
  end

  ##################################
  #  attr_delete_does_not_cascade  #
  ##################################

  def attr_delete_does_not_cascade( *attributes )
    
    attributes.each do |this_attribute|
      delete_cascades[ this_attribute.accessor_name ] = false
    end
    
    return self
    
  end

  ###########################
  #  attr_delete_cascades!  #
  ###########################

  def attr_delete_cascades!

    return attr_delete_cascades( *persistent_attributes.keys )

  end


  ###################################
  #  attr_delete_does_not_cascade!  #
  ###################################

  def attr_delete_does_not_cascade!

    return attr_delete_does_not_cascade( *persistent_attributes.keys )

  end

end
