
module ::Persistence::Port::Bucket::ClassInstance

  include ::CascadingConfiguration::Setting

  attr_configuration :instance_persistence_bucket

  ##################################
  #  instance_persistence_bucket=  #
  #  store_as                      #
  #  persists_in                   #
  ##################################

  # declare name of persistence bucket where object instances will be stored
  def instance_persistence_bucket=( persistence_bucket_class_or_name )

    if ! persistence_bucket_class_or_name

      super( nil )

    elsif ! ( persistence_bucket_class_or_name.is_a?( String )  or 
              persistence_bucket_class_or_name.is_a?( Symbol ) )   and 
          persistence_bucket_class_or_name.respond_to?( :persistence_bucket )

      # if arg responds to :persistence_bucket we use arg's bucket
      super( persistence_bucket_class_or_name.persistence_bucket )
    
    else

      bucket_instance = nil
      
      if instance_persistence_port
        bucket_instance = instance_persistence_port.persistence_bucket( persistence_bucket_class_or_name.to_s )
      else
        bucket_instance = ::Persistence.pending_bucket( self, persistence_bucket_class_or_name.to_s )
      end
      
      super( bucket_instance )
    
    end

    return self
    
  end

  alias_method :store_as, :instance_persistence_bucket=
  alias_method :persists_in, :instance_persistence_bucket=
  
  #################################
  #  instance_persistence_bucket  #
  #################################

  def instance_persistence_bucket

    bucket_instance = nil
    
    unless bucket_instance = super
      self.instance_persistence_bucket = to_s
      bucket_instance = super
    end
    
    return bucket_instance
    
  end

end
