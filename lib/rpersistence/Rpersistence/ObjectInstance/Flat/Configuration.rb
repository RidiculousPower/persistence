
#-----------------------------------------------------------------------------------------------------------#
#------------------------------  Persistence Flat Object Configuration  ------------------------------------#
#-----------------------------------------------------------------------------------------------------------#

module Rpersistence::ObjectInstance::Flat::Configuration

  ###############################
  #  Klass.persistence_bucket=  #
  #  persistence_bucket=        #
  ###############################

  # declare name of persistence bucket where object will be stored
  def persistence_bucket=( persistence_bucket_class_or_name )

    @__rpersistence__bucket__ = persistence_bucket_class_or_name.to_s

  end

end
