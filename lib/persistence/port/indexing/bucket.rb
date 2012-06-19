
module ::Persistence::Port::Indexing::Bucket

  ################
  #  initialize  #
  ################

  def initialize( parent_port, bucket_name )

    # initialization for :initialize_bucket_for_port has to take place before calling super
    # this is because super will already call :initialize_bucket_for_port
    @indexes = { }
    @pending_indexes = [ ]

    super if defined?( super )
  
  end

  ################################
  #  initialize_bucket_for_port  #
  ################################
  
  def initialize_bucket_for_port( port )
  
    super

    @indexes.each do |this_index_name, this_index_instance|
      this_index_instance.initialize_for_bucket( self )
    end
    
    @pending_indexes.delete_if do |this_pending_index|
      this_pending_index.initialize_for_bucket( self )
      true
    end
  
  end

  ##################
  #  create_index  #
  ##################
  
  def create_index( index_name, sort_by_proc = nil, & bucket_indexing_block )
    
    unless block_given?
      raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::BlockRequired,
            'Block required for bucket index.'
    end
    
    # bucket indexes are held and run by the buckets that define them
    return create_bucket_index( index_name, false, sort_by_proc, & bucket_indexing_block )
    
  end

  ##################################
  #  create_index_with_duplicates  #
  ##################################
  
  def create_index_with_duplicates( index_name, sort_by_proc = nil, sort_duplicates_by_proc = nil, & bucket_indexing_block )

    unless block_given?
      raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::BlockRequired,
            'Block required for bucket index.'
    end

    return create_bucket_index( index_name, true, sort_by_proc, sort_duplicates_by_proc, & bucket_indexing_block )
    

  end

  #####################################
  #  create_explicit_index_for_class  #
  #####################################

  def create_explicit_index_for_class( permits_duplicates, index_name, sort_duplicates_by_proc = nil, & sort_by_block )

    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( index_name, 
                                                                      self, 
                                                                      permits_duplicates,
                                                                      sort_by_block,
                                                                      sort_duplicates_by_proc )

    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::ExplicitIndex )
    
    return index_instance
    
  end

  ##################################
  #  create_block_index_for_class  #
  ##################################

  def create_block_index_for_class( permits_duplicates, index_name, sort_by_proc = nil, sort_duplicates_by_proc = nil, & indexing_block )
    
    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( index_name, 
                                                                      self, 
                                                                      permits_duplicates,
                                                                      sort_by_proc,
                                                                      sort_duplicates_by_proc )

    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::BlockIndex )
    
    unless block_given?
      raise ::Persistence::Port::Indexing::Bucket::Index::Exceptions::BlockRequired,
            'Block required for block index.'
    end
    
    index_instance.indexing_procs.push( indexing_block )

    return index_instance
    
  end

  ######################################
  #  create_attribute_index_for_class  #
  ######################################

  def create_attribute_index_for_class( permits_duplicates, attribute, sort_duplicates_by_proc = nil, & sort_by_block )

    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( attribute, 
                                                                      self, 
                                                                      permits_duplicates,
                                                                      sort_by_block,
                                                                      sort_duplicates_by_proc )

    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::AttributeIndex )

    index_instance.attribute_name = attribute

    return index_instance
    
  end

  ################
  #  pend_index  #
  ################
  
  def pend_index( index_instance )
    
    @pending_indexes.push( index_instance )
    
  end
  
  ###########
  #  index  #
  ###########
  
  def index( index_name )
    
    return @indexes[ index_name ]
    
  end

  ################
  #  has_index?  #
  ################
  
  def has_index?( index_name )
    
    return ( @indexes[ index_name ] ? true : false )
    
  end

  ###########
  #  count  #
  ###########

  def count( index_name = nil ) 

    return_value = 0
    
    if index_name
      return_value = index( index_name ).count
    else
      return_value = adapter_bucket.count
    end

    return return_value

  end

  #############################
  #  delete_index_for_object  #
  #############################

  def delete_index_for_object( object, index_name )
    return delete_index_for_object_id( object.persistence_id )
  end

  ################################
  #  delete_index_for_object_id  #
  ################################
  
  def delete_index_for_object_id( global_id, index_name )
    return adapter_bucket.delete_index_for_object_id( global_id )
  end
  
  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  #########################
  #  create_bucket_index  #
  #########################
  
  def create_bucket_index( index_name, permits_duplicates, sort_by_proc = nil, sort_duplicates_by_proc = nil, & bucket_block )
  
    if index_instance = @indexes[ index_name ] and index_instance.permits_duplicates? != permits_duplicates
      raise 'Index ' + @name.to_s + ' has already been declared, ' +
            'and new duplicates declaration does not match existing declaration.'
    end

    index_instance = ::Persistence::Port::Indexing::Bucket::Index.new( index_name, 
                                                                      self, 
                                                                      permits_duplicates )

    index_instance.extend( ::Persistence::Port::Indexing::Bucket::Index::BucketIndex )
    
    index_instance.indexing_procs.push( bucket_block )
    
    @indexes[ index_name ] = index_instance
    
    return index_instance
    
  end
  

end
