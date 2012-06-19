
module ::Persistence::Port::ClassInstance

  include ::Persistence::Port::Bucket::ClassInstance
  include ::Persistence::Port::FilePersistence

  include ::CascadingConfiguration::Setting

  attr_configuration :instance_persistence_port
  
  ################################
  #  instance_persistence_port=  #
  #  store_using                 #
  #  persists_using              #
  ################################

  def instance_persistence_port=( port_object_port_or_port_name )

    port = nil

    if port_object_port_or_port_name.nil?

      super( nil )
      
    elsif port_object_port_or_port_name.is_a?( ::Persistence::Port )

      port = port_object_port_or_port_name
      
    elsif port_object_port_or_port_name.respond_to?( :instance_persistence_port )
      
      # if arg responds to :instance_persistence_port we use arg's instance port
      port = port_object_port_or_port_name.instance_persistence_port
    
    elsif ! port_object_port_or_port_name.is_a?( String ) and 
          ! port_object_port_or_port_name.is_a?( Symbol ) and
          port_object_port_or_port_name.respond_to?( :persistence_port )
      
      # if arg responds to :persistence_port we use arg's port
      port = port_object_port_or_port_name.persistence_port
          
    else

      port = ::Persistence.port_for_name_or_port( port_object_port_or_port_name )
    
    end

    super( port ) if port
    
    # also we need to reset the bucket since we changed ports
    self.instance_persistence_bucket = nil
    
    return port
    
  end
  alias_method :store_using,    :instance_persistence_port=
  alias_method :persists_using, :instance_persistence_port=

  ###############################
  #  instance_persistence_port  #
  ###############################

  def instance_persistence_port

    return super || ( self.instance_persistence_port = ::Persistence.current_port )
    
  end

end
