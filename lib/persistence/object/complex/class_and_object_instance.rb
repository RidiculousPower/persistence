
module ::Persistence::Object::Complex::ClassAndObjectInstance

  include ::CascadingConfiguration::Hash

  ##########################
  #  attr_delete_cascades  #
  ##########################

  attr_configuration_hash :delete_cascades

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

  ######################
  #  delete_cascades?  #
  ######################

  def delete_cascades?( variable_name )

    should_cascade = false

    accessor_name = variable_name.accessor_name

    # delete_cascades is a cascading array that automatically handles inheritance
    if ( should_cascade = delete_cascades[ accessor_name ] ) == nil

      if attribute_value = persistence_port.get_attribute( self, accessor_name ) and
         attribute_value.is_a?( ::Persistence::Object::Complex::ComplexObject )

        should_cascade = attribute_value.delete_cascades?

      end

      should_cascade = true if should_cascade.nil?
      delete_cascades[ accessor_name ] = should_cascade

    end

    return should_cascade

  end

end
