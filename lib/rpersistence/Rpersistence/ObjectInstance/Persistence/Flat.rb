
#---------------------------------------------------------------------------------------------------------#
#------------------------------------------  Flat Instances  ---------------------------------------------#
#---------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Persistence::Flat
    
  #############################
  #  Klass.persistence_port=  #
  #  persistence_port=        #
  #############################
  
  def persistence_port=( port )

    @__rpersistence__port__ = port

    return self

  end

  ###############################
  #  Klass.persistence_bucket=  #
  #  persistence_bucket=        #
  ###############################

  # declare name of persistence bucket where object will be stored
  def persistence_bucket=( persistence_bucket_class_or_name )
    
    # we don't ever need to include/extend anything for flat classes like we do for complex objects
    
    @__rpersistence__bucket__ = persistence_bucket_class_or_name.to_s

  end
  alias_method :store_as, :persistence_bucket=

  ####################
  #  Klass.persist!  #
  #  persist!        #
  ####################

  def persist!( key )

    self.persistence_key = key

    persistence_port.adapter.put_object!( self )

		index_attributes

    # return the object we're persisting
    return self
  
  end

end

