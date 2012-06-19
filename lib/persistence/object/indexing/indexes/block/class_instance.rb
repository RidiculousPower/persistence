
module ::Persistence::Object::Indexing::Indexes::Block::ClassInstance

  #################
  #  block_index  #
  #################
  
  def block_index( index_name, & indexing_block )

    instance = instance_persistence_bucket.create_block_index_for_class( false, 
                                                                         index_name, 
                                                                         & indexing_block )
    indexes[ index_name ] = block_indexes[ index_name ] = instance

    return self
    
  end

  #########################
  #  block_index_ordered  #
  #########################
  
  def block_index_ordered( index_name, ordering_proc, & indexing_block )

    instance = instance_persistence_bucket.create_block_index_for_class( false, 
                                                                         index_name, 
                                                                         & indexing_block )
    indexes[ index_name ] = block_indexes[ index_name ] = instance

    return self

  end
  
  #################################
  #  block_index_with_duplicates  #
  #################################
  
  def block_index_with_duplicates( index_name, & indexing_block )

    instance = instance_persistence_bucket.create_block_index_for_class( true, 
                                                                         index_name, 
                                                                         & indexing_block )
    indexes[ index_name ] = block_indexes[ index_name ] = instance

    return self

  end
  
  #########################################
  #  block_index_ordered_with_duplicates  #
  #########################################
  
  def block_index_ordered_with_duplicates( index_name, ordering_proc, duplicates_ordering_proc = nil, & indexing_block )

    instance = instance_persistence_bucket.create_block_index_for_class( true, 
                                                                         index_name, 
                                                                         ordering_proc,
                                                                         duplicates_ordering_proc,
                                                                         & indexing_block )
    indexes[ index_name ] = block_indexes[ index_name ] = instance

    return self

  end

  ######################
  #  has_block_index?  #
  ######################
  
  def has_block_index?( *index_names )
    
    has_index = false
    
    index_names.each do |this_index_name|
      break unless has_index = block_indexes.has_key?( this_index_name )
    end
    
    return has_index

  end
  
end
