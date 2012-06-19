
module ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString

  ###################################
  #  primary_key_for_attribute_name  #
  ###################################

  def primary_key_for_attribute_name( object, attribute_name )

    return self.class::SerializationClass.__send__( self.class::SerializationMethod, [ persistence_id, attribute_name ] )

  end

end
