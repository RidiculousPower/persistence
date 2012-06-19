
module ::Persistence::Port::Bucket::ObjectInstance

  include ::CascadingConfiguration::Setting
  
  attr_instance_configuration :persistence_bucket

  #########################
  #  persistence_bucket=  #
  #########################

  # declare name of persistence bucket where object will be stored
  def persistence_bucket=( persistence_bucket_class_or_name )
    
    if persistence_bucket_class_or_name.nil?
      
      super( nil )
      
    elsif persistence_bucket_class_or_name.is_a?( ::Persistence::Port::Bucket )
    
      super( persistence_bucket_class_or_name )
    
    elsif persistence_bucket_class_or_name.respond_to?( :instance_persistence_bucket )

      # if arg responds to :instance_persistence_bucket we use arg's bucket
      super( persistence_bucket_class_or_name.instance_persistence_bucket )

    elsif ! ( persistence_bucket_class_or_name.is_a?( String )  or 
              persistence_bucket_class_or_name.is_a?( Symbol ) )   and 
          persistence_bucket_class_or_name.respond_to?( :persistence_bucket )
      
      # if arg responds to :persistence_bucket we use arg's bucket
      super( persistence_bucket_class_or_name.persistence_bucket )
    
    else
      
      # otherwise we use arg as a symbol
      # this means classnames are ok (which are default)
      self.persistence_bucket = persistence_port.persistence_bucket( persistence_bucket_class_or_name.to_sym )
    
    end
    
    return self
    
  end

  ########################
  #  persistence_bucket  #
  ########################
  
  def persistence_bucket

    # if specified at instance level, use specified value
    # otherwise, use value stored in class
    return super || self.class.instance_persistence_bucket

  end
  
end

