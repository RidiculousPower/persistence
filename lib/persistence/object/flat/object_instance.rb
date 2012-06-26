
###
# Instance methods for flat objects enabled with persistence capabilities.
#
module ::Persistence::Object::Flat::ObjectInstance

  ##############################
  #  persistence_hash_to_port  #
  ##############################
  
  ###
  # @private
  #
  # Generate hash representing object.
  #
  # @return [Hash] Hash representing information to reproduce object instance.
  #
  def persistence_hash_to_port

    return { persistence_bucket.primary_key_for_attribute_name( self, self.class.to_s ) => self }

  end

end
