
###
# Instance methods for flat objects enabled with persistence capabilities.
#
module ::Persistence::Object::Flat::ObjectInstance

  ##############################
  #  persistence_hash_to_port  #
  ##############################

  def persistence_hash_to_port

    return { persistence_bucket.primary_key_for_attribute_name( self, self.class.to_s ) => self }

  end

end
