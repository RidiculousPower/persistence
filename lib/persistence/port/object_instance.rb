
module ::Persistence::Port::ObjectInstance
  
  include ::CascadingConfiguration::Setting
  
  include ::Persistence::Port::Bucket::ObjectInstance
  include ::Persistence::Port::FilePersistence

  attr_local_configuration :persistence_port

  #######################
  #  persistence_port=  #
  #######################

  # declare name of persistence port where object will be stored
  def persistence_port=( persistence_port_class_or_name )

    # we don't check instance_persistence_port here
    # if there is no persistence_port then the internals cascade upward
    # this means internals check instance_persistence_port if appropriate
    if persistence_port_class_or_name.respond_to?( :persistence_port )
      
      # if arg responds to :persistence_port we use arg's port
      super( persistence_port_class_or_name.persistence_port )
    
    else
      
      super( persistence_port_class_or_name )
    
    end
    
    return self
    
  end

  ######################
  #  persistence_port  #
  ######################
  
  def persistence_port

    # if specified at instance level, use specified value
    # otherwise, use value stored in class  
    return super || self.class.instance_persistence_port

  end
  
end
