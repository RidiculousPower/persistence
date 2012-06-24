
module ::Persistence::Object::Complex::ClassInstance

  include ::Persistence::Object::Complex::Attributes
  
  include ::Persistence::Object::Complex::ClassAndObjectInstance
  
  ################
  #  attr_index  #
  ################

  def attr_index( *attributes )

   parent_bucket = instance_persistence_bucket

   attributes.each do |this_attribute|
     index_instance = ::Persistence::Object::Complex::Index::AttributeIndex.new( this_attribute, parent_bucket, false )
     index_instance.attribute_name = this_attribute
     indexes[ this_attribute ] = attribute_indexes[ this_attribute ] = index_instance
   end

   return self

  end

  ########################
  #  attr_index_ordered  #
  ########################

  def attr_index_ordered( attributes, & ordering_block )
 
   raise 'pending'
 
   parent_bucket = instance_persistence_bucket

   attributes.each do |this_attribute|
     index_instance = ::Persistence::Object::Complex::Index::AttributeIndex.new( this_attribute, 
                                                                                 parent_bucket,
                                                                                 true,
                                                                                 ordering_block )
     index_instance.attribute_name = this_attribute
     indexes[ this_attribute ] = attribute_indexes[ this_attribute ] = index_instance
   end

   return self

  end

  ################################
  #  attr_index_with_duplicates  #
  ################################

  def attr_index_with_duplicates( attribute )

   index_instance = ::Persistence::Object::Complex::Index::AttributeIndex.new( attribute, 
                                                                               instance_persistence_bucket, 
                                                                               true )
   index_instance.attribute_name = attribute
   indexes[ attribute ] = attribute_indexes[ attribute ] = index_instance

   return self

  end

  ########################################
  #  attr_index_ordered_with_duplicates  #
  ########################################

  def attr_index_ordered_with_duplicates( attribute, duplicates_ordering_proc = nil, & ordering_block )

    raise 'pending'

    index_instance = ::Persistence::Object::Complex::Index::AttributeIndex.new( attribute, 
                                                                                parent_bucket,
                                                                                true,
                                                                                ordering_block,
                                                                                duplicates_ordering_proc )
    index_instance.attribute_name = attribute
    indexes[ attribute ] = attribute_indexes[ attribute ] = index_instance

    return self

  end

  ############
  #  cease!  #
  ############

  def cease!( *args )

    if persistence_hash_in_port = super

      persistence_hash_in_port.each do |this_attribute, this_value|

        if this_value.is_a?( ::Persistence::Object::Complex::ComplexObject ) and 
           delete_cascades?( global_id, this_value.persistence_id )

          this_value.cease!

        end

      end

    end
    
    return persistence_hash_in_port
    
  end
  
end
