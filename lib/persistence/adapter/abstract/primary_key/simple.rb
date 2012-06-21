
###
# Provides primary key with attribute name to including adapter class.
#
module ::Persistence::Adapter::Abstract::PrimaryKey::Simple

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  ###
  # Returns a primary key for storage in adapter (self). Generated from object instance and attribute name. 
  #  Any further constraints are a function of the adapter's requirements, not of Persistence.
  #  This implementation simply returns the attribute name.
  #
  # @param object Object instance for which to generate primary key.
  # @param attribute_name Attribute name key refers to.
  #
  # @return String Primary key for use in adapter (self).
  #
  def primary_key_for_attribute_name( object, attribute_name )

    return attribute_name

  end

end
