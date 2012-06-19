
module ::Persistence::Port::Indexing::Bucket::Index::AdapterInterface

  ###################
  #  adapter_index  #
  ###################
  
  def adapter_index
    
    raise 'Persistence port must be enabled first.' unless @adapter_index
    
    return @adapter_index
    
  end

  ###########
  #  count  #
  ###########

  def count 

    return adapter_index.count

  end

  #########################
  #  permits_duplicates?  #
  #########################

  def permits_duplicates?
    
    return ( permits_duplicates ? true : false )

  end
  
  ################
  #  persisted?  #
  ################

  def persisted?( key )

    return ( get_object_id( key ) ? true : false )

  end

  ###################
  #  get_object_id  #
  ###################

  def get_object_id( key )

    return adapter_index.get_object_id( key )
  
  end

  ##################
  #  index_object  #
  ##################

  def index_object( object, key )

    return index_object_id( object.persistence_id, key )

  end

  #####################
  #  index_object_id  # 
  #####################
                     
  def index_object_id( global_id, key )

    return adapter_index.index_object_id( global_id, key )

  end

  #############################
  #  delete_keys_for_object!  #
  #############################

  def delete_keys_for_object!( object )

    return delete_keys_for_object_id!( object.persistence_id )
    
  end

  ################################
  #  delete_keys_for_object_id!  #
  ################################

  def delete_keys_for_object_id!( global_id )

    return adapter_index.delete_keys_for_object_id!( global_id )

  end

end
