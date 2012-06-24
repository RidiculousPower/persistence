
###
# @private
###
# Provides primary key with the object's persistence_id and the attribute name, connected by
#  self.class::Delimiter in including adapter class.
#
module ::Persistence::Adapter::Abstract::PrimaryKey::IDPropertyString

  ####################################
  #  primary_key_for_attribute_name  #
  ####################################

  ###
  # Returns a primary key for storage in adapter (self). Generated from object instance and attribute name. 
  #  Any further constraints are a function of the adapter's requirements, not of Persistence.
  #  This implementation returns a string with the object's persistence_id and the attribute name, connected by
  #  self.class::Delimiter in including adapter class.
  #
  # @param object Object instance for which to generate primary key.
  # @param attribute_name Attribute name key refers to.
  #
  # @return String Primary key for use in adapter (self).
  #
  def primary_key_for_attribute_name( object, attribute_name )

    return object.persistence_id.to_s << self.class::Delimiter << attribute_name.to_s

  end

end
