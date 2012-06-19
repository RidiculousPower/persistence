
module ::Persistence::Port::Interface

  attr_reader :name

  ################
  #  initialize  #
  ################

  def initialize( port_name, adapter_instance )

    super() if defined?( super )
    
    @adapter_buckets = { }
    
    @name    = port_name
    @adapter = adapter_instance
    
  end
  
  ############
  #  enable  #
  ############

  def enable
    @enabled = true
    @adapter.enable
    return self
  end

  ##############
  #  enabled?  #
  ##############

  def enabled?
    return @enabled
  end

  ###############
  #  disabled?  #
  ###############

  def disabled?
    return ! @enabled
  end
  
  #############
  #  disable  #
  #############

  def disable
    @enabled = false
    @adapter.disable
    return self
  end

  ########################
  #  persistence_bucket  #
  ########################

  def persistence_bucket( bucket_name )
    
    bucket_instance = nil
    
    bucket_name = bucket_name.to_sym

    unless bucket_instance = @adapter_buckets[ bucket_name ]
      @adapter_buckets[ bucket_name ] = bucket_instance = ::Persistence::Port::Bucket.new( self, bucket_name )
    end
    
    return bucket_instance
    
  end

end
