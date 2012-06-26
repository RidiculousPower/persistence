
###
# Methods applied to Class instances of complex objects enabled with persistence capabilities.
#
module ::Persistence::Object::Complex::ClassInstance

  include ::Persistence::Object::Complex::Attributes
  
  include ::Persistence::Object::Complex::ClassAndObjectInstance
  
  include ::CascadingConfiguration::Array::Unique
  
  ################
  #  attr_index  #
  ################

  ###
  # Declare an index on attribute(s).
  #
  # @overload attr_index( attribute_name, ... )
  #
  #   @param attribute_name Name of object property to index. Creates accessor if method by name 
  #     does not already exist.
  #
  # @return self
  #
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

  ###
  # Declare an ordered index on attribute(s). PENDING.
  #
  # @overload attr_index( attribute_name, ... )
  #
  #   @param attribute_name Name of object property to index. Creates accessor if method by name 
  #     does not already exist.
  #
  # @return self
  #
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

  ###
  # Declare an index permitting duplicates on attribute(s).
  #
  # @overload attr_index_with_duplicates( attribute_name, ... )
  #
  #   @param attribute_name Name of object property to index. Creates accessor if method by name 
  #     does not already exist.
  #
  # @return self
  #
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

  ###
  # Declare an ordered index permitting duplicates on attribute(s). PENDING.
  #
  # @overload attr_index_ordered_with_duplicates( attribute_name, ... )
  #
  #   @param attribute_name Name of object property to index. Creates accessor if method by name 
  #     does not already exist.
  #
  # @return self
  #
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

  ##########################
  #  has_attribute_index?  #
  ##########################
  
  ###
  # Query whether attribute index(es) exist for object.
  #
  # @overload has_attribute_index?( index_name, ... )
  #
  #   @param index_name Name of requested index.
  #
  # @return [true,false] Whether index(es) exist.
  #
  def has_attribute_index?( *attributes )
  
    has_index = false
  
    attributes.each do |this_attribute|
      break unless has_index = attribute_indexes.has_key?( this_attribute.accessor_name )
    end
  
    return has_index
  
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
  
  ###############
  #  attr_flat  #
  ###############

  ###
  # Declare that an attribute should be treated as a flat object by persistence port, regardless whether it
  #   actually is a flat object.
  #
  # @overload attr_flat( attribute_name, ... )
  #   
  #   @param attribute_name Name of attribute to treat as flat object.
  #
  # @return self
  #
  def attr_flat( *attributes )

    if attributes.empty?
      persists_flat[ nil ] = true
    else
      attributes.each do |this_attribute|
        persists_flat.push( this_attribute )
      end
    end
    
    return self
    
  end

  ################
  #  attr_flat!  #
  ################

  ###
  # Declare {self#attr_flat} on all attributes.
  # 
  # @return self
  #
  def attr_flat!
    
    attr_flat( *persistent_attribute_writers )

    return self
    
  end

  ####################
  #  persists_flat?  #
  ####################

  ###
  # Query whether attribute(s) are being treated explicitly as flat objects.
  #
  # @overload has_attribute_index?( attribute_name, ... )
  #
  #   @param attribute_name Attribute(s) in question.
  #
  # @return [true,false] Whether attributes(es) are being treated explicitly as flat objects.
  #
  def persists_flat?( *attributes )

    should_persist_flat = false

    if attributes.empty?
      should_persist_flat = persists_flat.include?( nil )
    else
      attributes.each do |this_attribute|
        break unless should_persist_flat = persists_flat.include?( this_attribute )
      end
    end
    
    return should_persist_flat
    
  end

  ###################
  #  persists_flat  #
  ###################

  ###
  # @method persists_flat
  #
  # Hash that tracks attributes specified to persist as if they are flat objects.
  #
  # @return [CompositingHash{Symbol,String=>true}] Hash with attribute details.
  #
  attr_unique_array :persists_flat

end
