
module ::Persistence::Object::Indexing::Indexes::Explicit::ClassInstance
  
  ####################
  #  explicit_index  #
  ####################
  
  def explicit_index( *index_names )

    index_names.each do |this_index_name|
      instance = instance_persistence_bucket.create_explicit_index_for_class( false, 
                                                                              this_index_name )
      indexes[ this_index_name ] = explicit_indexes[ this_index_name ] = instance
    end
    
    return self

  end

  ############################
  #  explicit_index_ordered  #
  ############################
  
  def explicit_index_ordered( *index_names, & ordering_block )
    
    index_names.each do |this_index_name|
      instance = instance_persistence_bucket.create_explicit_index_for_class( false, 
                                                                              this_index_name,
                                                                              & ordering_block )
      indexes[ this_index_name ] = explicit_indexes[ this_index_name ] = instance
    end
    
    return self

  end

  ####################################
  #  explicit_index_with_duplicates  #
  ####################################
  
  def explicit_index_with_duplicates( index_name )

    instance = instance_persistence_bucket.create_explicit_index_for_class( true, 
                                                                            index_name )
    indexes[ index_name ] = explicit_indexes[ index_name ] = instance
    
    return self
    
  end

  ############################################
  #  explicit_index_ordered_with_duplicates  #
  ############################################
  
  def explicit_index_ordered_with_duplicates( index_name, duplicates_ordering_proc = nil, & ordering_block )

    instance = instance_persistence_bucket.create_explicit_index_for_class( true, 
                                                                            index_name,
                                                                            duplicates_ordering_proc,
                                                                            & ordering_block )
    indexes[ index_name ] = explicit_indexes[ index_name ] = instance
    
    return self
    
  end

  #########################
  #  has_explicit_index?  #
  #########################
  
  def has_explicit_index?( *index_names )
    
    has_index = false
    
    index_names.each do |index_name|
      break unless has_index = explicit_indexes.has_key?( index_name )
    end
    
    return has_index
    
  end

end
