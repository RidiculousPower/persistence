
###
# Controller methods for Persistence singleton.
#
module ::Persistence::Port::Controller

  ###################
  #  self.extended  #
  ###################

  ###
  # Initializes singleton when extended.
  #
  def self.extended( instance )
    
    instance.module_eval do
      @ports = { }
      @pending_buckets = { }
    end
    
  end
  
  ###########
  #  ports  #
  ###########

  ###
  # Tracks persistence ports.
  #
  # @return [Hash{Symbol,String=>Persistence::Port}] Hash of ports.
  def ports
    
    return @ports

  end

  #####################
  #  pending_buckets  #
  #####################
  
  ###
  # @private
  #
  # Tracks pending persistence buckets created before a port is enabled.
  #
  # @return [Hash{Symbol,String=>Persistence::Port::Bucket}]
  #
  def pending_buckets

    return @pending_buckets

  end
  
  #################
  #  enable_port  #
  #################

  ###
  # Enable a port. If no port is already enabled, port will be set as current port.
  #
  # @param port_name Name of port to create or enable.
  #
  # @param adapter_instance Adapter instance to use to create port. If not provided attempt will be made to
  #   enable existing port by name.
  #
  # @return [Persistence::Port] Port instance.
  #
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

  ###
  # Disable port.
  #
  # @param port_name Port name to disable.
  #
  # @return self
  #
  def disable_port( port_name )
    
    if port_instance = port( port_name )
    
      if current_port == port_instance
        set_current_port( nil )
      end
    
      port_instance.disable

    end
    
    return self

  end

  ##################
  #  current_port  #
  ##################
  
  ###
  # Get current port
  # 
  # @return [Persistence::Port,nil] Current port.
  #
  def current_port
    return @current_port
  end

  ######################
  #  set_current_port  #
  ######################
  
  ###
  # Set current port
  #
  # @param persistence_port_or_name Port instance or name to set current port to.
  #
  # @return self
  #
  def set_current_port( persistence_port_or_name )
    @current_port = port_for_name_or_port( persistence_port_or_name )
    return self
  end

  ##########
  #  port  #
  ##########
  
  ###
  # Get port for name.
  #
  # @param port_name Port name.
  #
  # @return [Persistence::Port] Port instance.
  #
  def port( port_name )
    return @ports[ port_name.to_sym ]
  end

  ###########################
  #  port_for_name_or_port  #
  ###########################
  
  ###
  # Get port for name.
  #
  # @param persistence_port_or_name Port name or instance.
  # @param ensure_exists Whether exception should be thrown is port does not exist.
  #
  # @return [Persistence::Port] Port instance.
  #
  def port_for_name_or_port( persistence_port_or_name, ensure_exists = false )
    
    port_instance = nil
    
    case persistence_port_or_name
      when ::Symbol, ::String
        port_instance = port( persistence_port_or_name )
      else
        port_instance = persistence_port_or_name
    end
    
    unless port_instance
      if ensure_exists
        raise ::ArgumentError, 'No port found by name ' << persistence_port_or_name.to_s
      end
    end
    
    return port_instance
    
  end

  ############################
  #  create_pending_buckets  #
  ############################

  ###
  # @private
  #
  # Creates pending buckets when port is enabled.
  # 
  # @param port Port to create pending buckets with.
  #
  # @return self
  #
  def create_pending_buckets( port )
    
    @pending_buckets.delete_if do |this_class, this_bucket|
      this_bucket.initialize_for_port( port )
      true
    end

    return self
    
  end

  ####################
  #  pending_bucket  #
  ####################
  
  ###
  # @private
  #
  # Create pending bucket to be enabled with port is enabled.
  #
  # @param klass Class bucket is being created for.
  # @param bucket_name Name to use for bucket.
  #
  # @return [Persistence::Port::Bucket]
  #
  def pending_bucket( klass, bucket_name )

    bucket_instance = nil

    unless bucket_instance = @pending_buckets[ klass ] and bucket_instance.name == bucket_name
      @pending_buckets[ klass ] = bucket_instance = ::Persistence::Port::Bucket.new( nil, bucket_name )
    end
    
    return bucket_instance
    
  end

end
