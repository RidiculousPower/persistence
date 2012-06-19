
module ::Persistence::Object::Complex::Indexing::Indexes::Attributes::ClassInstance

  ################
  #  attr_index  #
  ################

  def attr_index( *attributes )
    
    attributes.each do |this_attribute|
      instance = instance_persistence_bucket.create_attribute_index_for_class( false, 
                                                                               this_attribute )
      indexes[ this_attribute ] = attribute_indexes[ this_attribute ] = instance
    end
    
    return self
    
  end

  ########################
  #  attr_index_ordered  #
  ########################

  def attr_index_ordered( *attributes, & ordering_block )
    
    attributes.each do |this_attribute|
      instance = instance_persistence_bucket.create_attribute_index_for_class( false, 
                                                                               this_attribute )
      indexes[ this_attribute ] = attribute_indexes[ this_attribute ] = instance
    end
    
    return self
    
  end

 ################################
 #  attr_index_with_duplicates  #
 ################################

  def attr_index_with_duplicates( attribute )

    instance = instance_persistence_bucket.create_attribute_index_for_class( true, 
                                                                             attribute )
    indexes[ attribute ] = attribute_indexes[ attribute ] = instance
    
    return self

   end

  ################################
  #  attr_index_with_duplicates  #
  ################################

   def attr_index_with_duplicates( attribute, duplicates_ordering_proc = nil, & ordering_block )

     instance = instance_persistence_bucket.create_attribute_index_for_class( true, 
                                                                              attribute )
     indexes[ attribute ] = attribute_indexes[ attribute ] = instance

     return self

    end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################
  
  ############################
  #  create_attribute_index  #
  ############################

  def create_attribute_index( permits_duplicates, *attributes )

     attributes.each do |this_index_name|

      if atomic_attribute_reader?( this_index_name )     or 
         non_atomic_attribute_reader?( this_index_name )
      elsif persists_atomic_by_default?
        attr_atomic_accessor( this_index_name )
      else
        attr_non_atomic_accessor( this_index_name )
      end

      this_index_instance = instance_persistence_bucket.create_attribute_index( permits_duplicates, 
                                                                               this_index_name )
      indexes[ this_index_name ] = attribute_indexes[ this_index_name ] = this_index_instance
      
     end


    return self
    
  end

end
