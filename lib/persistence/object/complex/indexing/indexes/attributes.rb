
module ::Persistence::Object::Complex::Indexing::Indexes::Attributes
  
  include ::CascadingConfiguration::Hash

   attr_configuration_hash :attribute_indexes
   
  ##########################
  #  has_attribute_index?  #
  ##########################
  
  def has_attribute_index?( *attributes )
    
    has_index = false
    attributes.each do |this_attribute|
      break unless has_index = attribute_indexes.has_key?( this_attribute.accessor_name )
    end

    return has_index

  end

  
end
