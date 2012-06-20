
module ::Persistence::Port::Bucket::Interface

  attr_accessor :parent_port, :name

  ################
  #  initialize  #
  ################

  def initialize( parent_port, bucket_name )

    @name = bucket_name

    if parent_port
      initialize_bucket_for_port( parent_port )
    end
    
  end

  ################################
  #  initialize_bucket_for_port  #
  ################################
  
  def initialize_bucket_for_port( port )

    @parent_port = ::Persistence.port_for_name_or_port( port )

    if @parent_port.enabled?
      @adapter_bucket = @parent_port.adapter.persistence_bucket( @name )
    end
    
  end
  
  ##############################
  #  disable_adapter_instance  #
  ##############################

  def disable_adapter_instance
    
    @adapter_bucket = nil
    
  end

end
