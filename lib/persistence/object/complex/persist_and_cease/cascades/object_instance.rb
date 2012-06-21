
module ::Persistence::Object::Complex::PersistAndCease::Cascades::ObjectInstance

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
