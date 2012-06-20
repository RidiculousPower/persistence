
module ::Persistence::Port::Controller

  ###################
  #  self.extended  #
  ###################

  def self.extended( instance )
    
    instance.module_eval do
      @ports = { }
      @pending_buckets = { }
    end
    
  end
  
  ###########
  #  ports  #
  ###########

  def ports
    
    return @ports

  end

  #####################
  #  pending_buckets  #
  #####################
  
  def pending_buckets

    return @pending_buckets

  end
  
  #################
  #  enable_port  #
  #################

  def enable_port( port_name, adapter_instance = nil )

    port_instance = nil

    if adapter_instance

      port_instance = ::Persistence::Port.new( port_name, adapter_instance )
      
      prior_port_by_name = @ports[ port_name.to_sym ]
      
      @ports[ port_name.to_sym ] = port_instance

      port_instance.enable
      
      if prior_port_by_name
        buckets_around_from_prior_port = prior_port_by_name.buckets
        buckets_around_from_prior_port.each do |this_bucket_name, this_bucket|
          port_instance.initialize_persistence_bucket_from_instance( this_bucket )
        end
      end
      
    else

      unless port_instance = port( port_name )
        raise 'Port must first be enabled with adapter instance before it can be re-enabled by name.'
      end

      port_instance.enable

    end

    unless current_port
      set_current_port( port_instance )
    end
    
    create_pending_buckets( port_instance )

    return port_instance

  end

  ##################
  #  disable_port  #
  ##################

  # ::Persistence.disable_port( :port_name )
  def disable_port( port_name )
    
    port_instance = port( port_name )
    
    if current_port == port_instance
      set_current_port( nil )
    end
    
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
    return @ports[ port_name.to_sym ]
  end

  ###########################
  #  port_for_name_or_port  #
  ###########################
  
  def port_for_name_or_port( persistence_port_or_name )
    
    port_instance = nil
    
    case persistence_port_or_name
      when ::Symbol, ::String
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
    
    @pending_buckets.delete_if do |this_class, this_bucket|
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

    unless bucket_instance = @pending_buckets[ klass ] and bucket_instance.name == bucket_name
      @pending_buckets[ klass ] = bucket_instance = ::Persistence::Port::Bucket.new( nil, bucket_name )
    end
    
    return bucket_instance
    
  end

end
