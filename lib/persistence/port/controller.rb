
module ::Persistence::Port::Controller

  #################
  #  enable_port  #
  #################

  def enable_port( port_name, adapter_instance = nil )

    port_instance = nil

    if adapter_instance

      port_instance = ::Persistence::Port.new( port_name, 
                                               adapter_instance )
      ports_hash[ port_name.to_sym ] = port_instance

    else

      unless port_instance = port( port_name )
        raise 'Port must first be enabled with adapter instance before it can be re-enabled by name.'
      end

    end

    port_instance.enable

    set_current_port( port_instance ) unless current_port

    create_pending_buckets( port_instance )

    return port_instance

  end

  ##################
  #  disable_port  #
  ##################

  # ::Persistence.disable_port( :port_name )
  def disable_port( port_name )
    
    port_instance = port( port_name )
    
    set_current_port( nil ) if current_port == port_instance
    
    port_instance.disable
    
    return self

  end

  ##################
  #  current_port  #
  ##################
  
  def current_port
    return @current_port
  end

  ######################
  #  set_current_port  #
  ######################
  
  def set_current_port( persistence_port_or_name )
    @current_port = port_for_name_or_port( persistence_port_or_name )
    return self
  end

  ##########
  #  port  #
  ##########
  
  def port( port_name )
    return ports_hash[ port_name.to_sym ]
  end

  ###########################
  #  port_for_name_or_port  #
  ###########################
  
  def port_for_name_or_port( persistence_port_or_name )
    
    port_instance = nil
    
    if persistence_port_or_name.is_a?( String ) or persistence_port_or_name.is_a?( Symbol )
      port_instance = port( persistence_port_or_name )
    else
      port_instance = persistence_port_or_name
    end
    
    return port_instance
    
  end

  ############################
  #  create_pending_buckets  #
  ############################

  def create_pending_buckets( port )
    
    pending_buckets_hash.delete_if do |this_class, this_bucket|
      this_bucket.initialize_bucket_for_port( port )
      true
    end
    
    return self
    
  end

  ####################
  #  pending_bucket  #
  ####################
    
  def pending_bucket( klass, bucket_name )

    bucket_instance = nil

    unless bucket_instance = pending_buckets_hash[ klass ] and bucket_instance.name == bucket_name
      pending_buckets_hash[ klass ] = bucket_instance = ::Persistence::Port::Bucket.new( nil, bucket_name )
    end
    
    return bucket_instance
    
  end

  ##################################################################################################
      private ######################################################################################
  ##################################################################################################

  ################
  #  ports_hash  #
  ################

  def ports_hash
    
    return @ports ||= { }

  end

  ##########################
  #  pending_buckets_hash  #
  ##########################
  
  def pending_buckets_hash

    return @pending_buckets_hash ||= { }

  end

end
