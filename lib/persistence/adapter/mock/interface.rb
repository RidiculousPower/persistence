
module ::Persistence::Adapter::Mock::Interface

  include ::Persistence::Adapter::Abstract::EnableDisable
  
  ################
  #  initialize  #
  ################

  def initialize( home_directory = nil )
    super() if defined?( super )
    @bucket_for_id = { }
    @class_for_id = { }
    @buckets = { }
  end
  
  ########################
  #  persistence_bucket  #
  ########################

  def persistence_bucket( bucket )
    
    bucket_instance = nil
    
    unless bucket_instance = @buckets[ bucket ]
      bucket_instance = ::Persistence::Adapter::Mock::Bucket.new( bucket )
      bucket_instance.parent_adapter = self    
      @buckets[ bucket ] = bucket_instance
    end
    
    return bucket_instance
    
  end

  ###################################
  #  get_bucket_name_for_object_id  #
  ###################################

  def get_bucket_name_for_object_id( global_id )

    return @bucket_for_id[ global_id ]
  
  end

  #############################
  #  get_class_for_object_id  #
  #############################

  def get_class_for_object_id( global_id )

    return @class_for_id[ global_id ]
    
  end

  #################################
  #  delete_bucket_for_object_id  #
  #################################

  def delete_bucket_for_object_id( global_id )

    return @bucket_for_id.delete( global_id )
  
  end

  ################################
  #  delete_class_for_object_id  #
  ################################

  def delete_class_for_object_id( global_id )

    return @class_for_id.delete( global_id )
    
  end

  ##########################################
  #  ensure_object_has_globally_unique_id  #
  ##########################################
  
  def ensure_object_has_globally_unique_id( object )

    unless object.persistence_id

      # in which case we need to create a new ID
      @id_sequence = ( @id_sequence ||= -1 ) + 1
      global_id = @id_sequence
      @bucket_for_id[ global_id ] = object.persistence_bucket.name
      @class_for_id[ global_id ] = object.class
      object.persistence_id = global_id

    end

    return object.persistence_id
  
  end

end
