
module ::Persistence::Port::Interface

  attr_reader :name

  ################
  #  initialize  #
  ################

  def initialize( port_name, adapter_instance )

    super() if defined?( super )
    
    @buckets = { }
    
    @name    = port_name
    @adapter = adapter_instance
    
    @enabled = false
    
  end
  
  ############
  #  enable  #
  ############

  def enable
    @enabled = true
    @adapter.enable
    @buckets.each do |this_bucket_name, this_bucket|
      this_bucket.initialize_bucket_for_port( self )
    end
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
    @buckets.each do |this_bucket_name, this_bucket|
      this_bucket.disable_adapter_instance
    end
    @adapter.disable
    return self
  end

  #############
  #  buckets  #
  #############

  attr_reader :buckets

  #################################################
  #  initialize_persistence_bucket_from_instance  #
  #################################################

  def initialize_persistence_bucket_from_instance( bucket_instance )

    @buckets[ bucket_instance.name.to_sym ] = bucket_instance

    bucket_instance.initialize_bucket_for_port( self )
    
    return bucket_instance
    
  end
  
  ########################
  #  persistence_bucket  #
  ########################

  def persistence_bucket( bucket_name )
    
    bucket_instance = nil

    bucket_name = bucket_name.to_sym

    unless bucket_instance = @buckets[ bucket_name ]
      @buckets[ bucket_name ] = bucket_instance = ::Persistence::Port::Bucket.new( self, bucket_name )
    end      
    
    return bucket_instance
    
  end

end
