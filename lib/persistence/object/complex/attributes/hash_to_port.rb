
class ::Persistence::Object::Complex::Attributes::HashToPort < ::Hash

  attr_accessor :persistence_object

  #########
  #  []=  #
  #########
  
  def []=( key, value )

    
    primary_key = nil
    attribute_value_to_port = nil
    
    # if we don't have a persistence port we want to compare objects by their properties
    if persistence_object.persistence_port
      attribute_key_to_port   = persistence_object.persist_as_sub_object_or_attribute_and_return_id_or_value( key )
      primary_key             = persistence_object.persistence_bucket.primary_key_for_attribute_name( persistence_object, attribute_key_to_port )
      attribute_value_to_port = persistence_object.persist_as_sub_object_or_attribute_and_return_id_or_value( value )
    else
      primary_key             = key
      attribute_value_to_port = value
    end
    
    super( primary_key, attribute_value_to_port )

  end
  
end
